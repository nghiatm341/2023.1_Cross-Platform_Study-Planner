const { ROLE, GENDER } = require("../constant/enum");
const User = require("../models/user");
const Otp = require("../models/otp");
const { comparePassword, cryptPassword } = require("../utils/hashPassword");
const { signToken, verifyToken } = require("../utils/jwt");
const { isValidateEmail, isValidDateTime, isValidPhoneNumber } = require("../constant/regex");
const nodeMailer = require("nodemailer");

class AuthController {
  async sendOtp(req, res) {
    try {
      const { email, isRegister } = req.body;

      if (!email || !isRegister) {
        return res.status(400).json({ message: "Missing information fields!" });
      }

      if (!isValidateEmail(email)) {
        return res.status(400).json({ message: "Email is invalid!" });
      }

      const findUser = await User.findOne({ email });
      if (findUser && +isRegister) {
        return res.status(400).json({
          message: "email already exists!",
        });
      }

      if (!findUser && !+isRegister) {
        return res.status(400).json({
          message: "email dose not exists!",
        });
      }

      const otp = Math.floor(Math.random() * (99999 - 10000 + 1)) + 10000;
      const html = `
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Account Verification</title>
        </head>
        <body>
            <p>Dear ${email},</p>
        
            <p>Welcome to Study-Planner App! To complete your account registration, please use the following OTP:</p>
        
            <p style="color: #0070cc; font-size: 1.2em; font-weight: bold;">${otp}</p>
        
            <p>Enter this code on our website to verify your email and activate your account.</p>
        
            <p>Thank you,<br>
            Study-Planner Team</p>
        </body>
        </html>
      `;

      const transporter = nodeMailer.createTransport({
        service: "gmail",
        auth: {
          user: "studyplanner252@gmail.com",
          pass: "smrh rkpu jhke jodw",
        },
      });
      const mailOptions = {
        from: "studyplanner252@gmail.com",
        to: email,
        subject: "Account Verification - Your OTP",
        html,
      };

      const currentDateTime = new Date();
      const maxId = await Otp.findOne().sort({ id: -1 }).exec();
      const id = +maxId?.id + 1 || 1;

      transporter.sendMail(mailOptions, async (error, info) => {
        if (error) {
          console.error(error);
        } else {
          const otpFind = await Otp.findOne({ email, is_delete: 0, expireAt: { $gt: new Date() } });
          if (otpFind) {
            await Otp.updateOne({ id: otpFind.id }, { is_delete: 1 });
          }
          const newData = new Otp({
            id,
            email,
            otp,
            expireAt: new Date(currentDateTime.getTime() + 5 * 60 * 1000),
          });
          await newData.save();

          return res.status(200).json({
            message: "check your mail to get Otp",
          });
        }
      });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async signUp(req, res) {
    try {
      let { email, password, firstName, lastName, role, otp } = req.body;
      if (!email || !password || !firstName || !lastName || !role || !otp) {
        return res.status(400).json({ message: "Missing information fields!" });
      }

      if (!isValidateEmail(email)) {
        return res.status(400).json({ message: "Email is invalid!" });
      }

      if (role !== ROLE.STUDENT && role !== ROLE.TEACHER) {
        return res.status(400).json({ message: "Role is invalid!" });
      }

      if (password.length < 6) {
        return res.status(400).json({ message: "Password minimum 6 characters!" });
      }

      const findUser = await User.findOne({ email });
      if (findUser) {
        return res.status(400).json({
          message: "email already exists!",
        });
      }

      const otpFind = await Otp.findOne({ email, is_delete: 0, expireAt: { $gt: new Date() } });
      if (otpFind?.otp !== +otp) {
        return res.status(400).json({ message: "Otp is invalid!" });
      }
      password = await cryptPassword(password);

      const maxId = await User.findOne({ is_delete: 0 }).sort({ id: -1 }).exec();
      const id = +maxId?.id + 1 || 1;

      const newData = new User({
        id,
        email,
        firstName,
        lastName,
        password,
        role,
        token: "",
        refreshToken: "",
        is_delete: 0,
      });

      const result = await newData.save();
      await Otp.updateOne({ id: otpFind.id }, { is_delete: 1 });

      return res.status(200).json({ message: "success", data: result });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async login(req, res) {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({ message: "Missing information fields!" });
      }

      if (!isValidateEmail(email)) {
        return res.status(400).json({ message: "Email is invalid!" });
      }

      const findUser = await User.find({ email });

      if (findUser.length === 0) {
        return res.status(404).json({
          message: "account does not exist!",
        });
      }

      const isMatchPassword = await comparePassword(password, findUser[0].password);
      if (isMatchPassword) {
        const token = await signToken({ id: findUser[0].id, userName: findUser[0].email, role: findUser[0].role });
        const refreshToken = await signToken({ id: findUser[0].id, userName: findUser[0].email });
        findUser[0].token = token;
        findUser[0].refreshToken = refreshToken;

        await User.updateOne({ email: findUser[0].email }, findUser[0]);
        return res.status(200).json({ message: "success", token, refreshToken });
      } else {
        return res.status(404).json({
          message: "login fail!",
          message: "email or password is incorrect !",
        });
      }
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async logout(req, res) {
    try {
      const id = req.userInfo.id;

      const findUser = await User.findOne({ id });
      if (!findUser) {
        return res.status(404).json({
          message: "account does not exist!",
        });
      }

      await User.updateOne({ id }, { token: "" });
      return res.status(200).json({
        message: "logout successful!",
      });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async updateInfo(req, res) {
    try {
      const { firstName, lastName, dob, phoneNumber, gender, avatar } = req.body;
      if (!isValidDateTime(dob)) {
        return res.status(400).json({
          message: "invalid dob!",
        });
      }
      if (gender !== GENDER.MALE && gender !== GENDER.FEMALE && gender !== GENDER.OTHER) {
        return res.status(400).json({ message: "invalid gender!" });
      }
      if (gender !== GENDER.MALE && gender !== GENDER.FEMALE && gender !== GENDER.OTHER) {
        return res.status(400).json({ message: "invalid gender!" });
      }
      if (!isValidPhoneNumber(phoneNumber)) {
        return res.status(400).json({ message: "invalid phone number!" });
      }
      if (firstName === "" && lastName === "" && avatar === "") {
        return res.status(400).json({ message: "empty strings are not allowed!" });
      }

      const id = req.userInfo.id;

      const findUser = await User.findOne({ id });
      if (!findUser) {
        return res.status(404).json({
          message: "account does not exist!",
        });
      }

      const updateValue = { firstName, lastName, dob, phoneNumber, gender, avatar };

      await User.updateOne({ id }, updateValue);
      return res.status(200).json({
        message: "sucess",
      });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async forgotPassword(req, res) {
    try {
      let { email, newPassword, otp } = req.body;
      if (newPassword.length < 6) {
        return res.status(400).json({ message: "Password minimum 6 characters!" });
      }
      const otpFind = await Otp.findOne({ email, is_delete: 0, expireAt: { $gt: new Date() } });
      console.log(otpFind);
      if (otpFind?.otp !== +otp) {
        return res.status(400).json({ message: "Otp is invalid!" });
      }
      const password = await cryptPassword(newPassword);
      console.log(password);
      await User.updateOne({ email }, { password });
      return res.status(200).json({ message: "Update password success!" });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new AuthController();
