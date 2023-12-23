const express = require("express");
const router = express.Router();
const AuthController = require("../controllers/auth.controller");
const { authRoleMiddleware, authOtpMiddleware } = require("../middlewares/auth.middleware");
const { ROLE, STATUS } = require("../constant/enum");
const schedule = require("node-schedule");
const user = require("../models/user");
const Report = require("../models/Report");

router.post("/sign-up", authOtpMiddleware(), AuthController.signUp);
router.post("/login", AuthController.login);
router.post("/logout", authRoleMiddleware(), AuthController.logout);
router.post("/send-otp", AuthController.sendOtp);
router.post("/verify-otp", AuthController.verifyOtp);

router.post("/admin/unblock", authRoleMiddleware(ROLE.ADMIN), AuthController.unblockUser);
router.post("/admin/block", authRoleMiddleware(ROLE.ADMIN), AuthController.blockUser);

// router.post("/user/update-info", authRoleMiddleware(), AuthController.updateInfo);
// router.post("/user/report", authRoleMiddleware(), AuthController.reportUser);
// router.post("/user/forget-password", authOtpMiddleware(), AuthController.forgotPassword);

const millisecondsPerDay = 86400000;
const dailyJob = schedule.scheduleJob(`*/${millisecondsPerDay / 1000} * * * * *`, async () => {
  try {
    const lowScoreUsers = await user.find({ status: STATUS.ACTIVE, score: { $lt: 1000 } });
    for (const user of lowScoreUsers) {
      if (user.score + 10 > 1000) {
        user.score = 1000;
        await user.save();
      } else {
        user.score += 10;
        await user.save();
      }
    }

    const blockedUsers = await user.find({ status: STATUS.BLOCK });
    for (const user of blockedUsers) {
      if (new Date() - user.updatedAt > millisecondsPerDay * 15 * user.count_block) {
        user.score = 750;
        user.status = STATUS.ACTIVE;
        await Report.updateMany({ reported_user_id: user.id }, { is_delete: 1 });
        await user.save();
      }
    }
  } catch (error) {
    console.error("Error in daily job:", error);
  }
});

module.exports = router;
