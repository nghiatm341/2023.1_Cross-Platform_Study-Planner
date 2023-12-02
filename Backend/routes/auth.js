const express = require("express");
const router = express.Router();
const AuthController = require("../controllers/auth.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const { ROLE } = require("../constant/enum");

router.post("/send-otp", AuthController.sendOtp);
router.post("/sign-up", AuthController.signUp);
router.post("/login", AuthController.login);
router.post("/logout", authMiddleware(), AuthController.logout);
router.post("/forget-password", AuthController.forgotPassword);
router.post("/update-info", authMiddleware(), AuthController.updateInfo);

module.exports = router;
