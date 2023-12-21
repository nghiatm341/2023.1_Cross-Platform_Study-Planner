const { GENDER, STATUS } = require("../constant/enum");
const { cryptPassword } = require("../utils/hashPassword");
const { isValidDateTime, isValidPhoneNumber } = require("../constant/regex");
const User = require("../models/user");
const Report = require("../models/Report");

class UserController {
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
      const result = await User.findOne({ id }).select("-password -token -refreshToken");
      return res.status(200).json({
        message: "success",
        data: result,
      });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async forgotPassword(req, res) {
    try {
      let { email, newPassword } = req.body;

      if (!email || !newPassword) {
        return res.status(400).json({ message: "Missing information fields!" });
      }

      if (newPassword.length < 6) {
        return res.status(400).json({ message: "Password minimum 6 characters!" });
      }

      if (email !== req.email) {
        return res.status(400).json({ message: "Email does not match the OTP entered previously!" });
      }
      const password = await cryptPassword(newPassword);
      await User.updateOne({ email }, { password });
      return res.status(200).json({ message: "Update password success!" });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async reportUser(req, res) {
    try {
      const { reportedUserId, levelReport } = req.body;
      const reporterId = req.userInfo.id;

      if (!reportedUserId || !levelReport) {
        return res.status(400).json({ message: "Missing information fields!" });
      }

      if (!Number.isInteger(+levelReport) || +levelReport < 1 || +levelReport > 5) {
        return res.status(400).json({ message: "levelReport has a value from 1 to 5!" });
      }

      if (+reportedUserId === 1) {
        return res.status(400).json({ message: "This person cannot be blocked!" });
      }

      if (+reporterId === +reportedUserId) {
        return res.status(400).json({ message: "Cannot report yourself!" });
      }

      const findUser = await User.findOne({ id: reportedUserId });

      if (!findUser) {
        return res.status(400).json({ message: "Not found user!" });
      }

      const findReport = await Report.findOne({
        reporter_id: reporterId,
        reported_user_id: reportedUserId,
        is_delete: 0,
      });
      if (findReport) {
        return res.status(400).json({ message: "Already reported this user!" });
      }

      switch (+levelReport) {
        case 1:
          findUser.score -= 15;
          break;
        case 2:
          findUser.score -= 25;
          break;
        case 3:
          findUser.score -= 50;
          break;
        case 4:
          findUser.score -= 75;
          break;
        case 5:
          findUser.score -= 1000;
          break;
      }

      if (findUser.score <= 0) {
        findUser.score = 0;
        findUser.status = STATUS.BLOCK;
        findUser.count_block++;
      }

      await findUser.save();

      const maxId = await Report.findOne().sort({ id: -1 }).exec();
      const id = +maxId?.id + 1 || 1;
      const newReport = new Report({
        id,
        reporter_id: reporterId,
        reported_user_id: reportedUserId,
      });
      await newReport.save();

      return res.status(200).json({ message: "success!" });
    } catch (error) {
      console.log("Error", error);
      res.status(500).json({ message: error.message });
    }
  }

  async getInfo(req, res) {
    const { userId } = req.body;

    const id = req.userInfo.id;

    if (!userId) {
      return res.status(400).json({ message: "Missing userId fields!" });
    }

    if (userId === 1 && id !== 1) {
      return res.status(401).json({
        message: "do not have permission to view this user information!",
      });
    }

    const findUser = await User.findOne({ id: userId }).select("-password -token -refreshToken");
    if (!findUser) {
      return res.status(404).json({
        message: "account does not exist!",
      });
    }

    return res.status(200).json({
      message: "success",
      data: findUser,
    });
  }

  async getListUser(req, res) {
    const findUser = await User.find({ id: { $ne: 1 } }).select("-password -token -refreshToken");

    return res.status(200).json({
      message: "success",
      data: findUser,
    });
  }

  async getListBlock(req, res){
    const findUser = await User.find({ status: 'block'}).select("-password -token -refreshToken");

    return res.status(200).json({
      message: "success",
      data: findUser,
    });
  }
}

module.exports = new UserController();
