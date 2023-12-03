const express = require("express");
const router = express.Router();
const { authRoleMiddleware, authOtpMiddleware } = require("../middlewares/auth.middleware");
const userController = require("../controllers/user.controller");

router.post("/update-info", authRoleMiddleware(), userController.updateInfo);
router.post("/report", authRoleMiddleware(), userController.reportUser);
router.post("/forget-password", authOtpMiddleware(), userController.forgotPassword);

module.exports = router;
