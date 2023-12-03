const { ROLE, GENDER, REASON_REPORT, STATUS } = require("../constant/enum");
const { comparePassword, cryptPassword } = require("../utils/hashPassword");
const { signToken, verifyToken } = require("../utils/jwt");
const { isValidateEmail, isValidDateTime, isValidPhoneNumber } = require("../constant/regex");
const nodeMailer = require("nodemailer");
const User = require("../models/user");
const Otp = require("../models/otp");
const Report = require("../models/Report");

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

      if (isRegister !== "0" && isRegister !== "1") {
        return res.status(400).json({ message: "isRegister is invalid!" });
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
      const htmlRegister = `
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
        
            <p>Thank you,<br>
            Study-Planner Team</p>
        </body>
        </html>
      `;

      const htmlChangePassword = `
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
        
            <p>You have requested to reset the password of your Study-Planner account! To reset your password, please use the following OTP:</p>
        
            <p style="color: #0070cc; font-size: 1.2em; font-weight: bold;">${otp}</p>
        
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
        html: !!Number(isRegister) ? htmlRegister : htmlChangePassword,
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

  async verifyOtp(req, res) {
    try {
      const { email, otp } = req.body;

      if (!email || !otp) {
        return res.status(400).json({ message: "Missing information fields!" });
      }

      if (!isValidateEmail(email)) {
        return res.status(400).json({ message: "Email is invalid!" });
      }

      const otpFind = await Otp.findOne({ email, is_delete: 0, expireAt: { $gt: new Date() } });
      if (!otpFind?.otp || otpFind?.otp !== +otp) {
        return res.status(400).json({ message: "Otp or email is incorrect!" });
      }
      await Otp.updateOne({ id: otpFind?.id }, { is_delete: 1 });

      const token = await signToken({ email }, 300);
      return res.status(200).json({ message: "Success", token });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async signUp(req, res) {
    try {
      let { email, password, firstName, lastName, role } = req.body;
      if (!email || !password || !firstName || !lastName || !role) {
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

      if (email !== req.email) {
        return res.status(400).json({ message: "Email does not match the OTP!" });
      }

      const findUser = await User.findOne({ email });
      if (findUser) {
        return res.status(400).json({
          message: "email already exists!",
        });
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
      // await Otp.updateOne({ id: otpFind?.id }, { is_delete: 1 });

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

      const findUser = await User.findOne({ email });

      if (!findUser) {
        return res.status(404).json({
          message: "account does not exist!",
        });
      }

      if (findUser.status === STATUS.BLOCK) {
        return res.status(403).json({
          message: "account has been block!",
          data: {
            blockedAt: findUser.updatedAt,
            duration: 15 * findUser.count_block + " days",
          },
        });
      }

      const isMatchPassword = await comparePassword(password, findUser.password);
      if (isMatchPassword) {
        const token = await signToken({ id: findUser.id, userName: findUser.email, role: findUser.role }, 86400 * 365);
        const refreshToken = await signToken({ id: findUser.id, userName: findUser.email });
        findUser.token = token;
        findUser.refreshToken = refreshToken;

        await User.updateOne({ email: findUser.email }, findUser);
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

  async unblockUser(req, res) {
    try {
      const { unblockedUserId, score } = req.body;

      if (!unblockedUserId || !score) {
        return res.status(400).json({ message: "Missing information fields!" });
      }

      if (!Number.isInteger(+score) || +score < 200 || +score > 1000) {
        return res.status(400).json({ message: "score has a value from 100 to 1000!" });
      }

      const findUserBlocked = await User.findOne({ id: unblockedUserId, status: STATUS.BLOCK });

      if (!findUserBlocked) {
        return res.status(400).json({ message: "the user does not exist or has not been blocked!" });
      }

      findUserBlocked.status = STATUS.ACTIVE;
      findUserBlocked.score = score;
      await findUserBlocked.save();
      await Report.updateMany({ reported_user_id: findUserBlocked.id }, { is_delete: 1 });

      return res.status(200).json({ message: "success!" });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new AuthController();
