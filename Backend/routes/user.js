const express = require("express");
const router = express.Router();
const { authRoleMiddleware, authOtpMiddleware } = require("../middlewares/auth.middleware");
const userController = require("../controllers/user.controller");
const { ROLE } = require("../constant/enum");

router.post("/update-info", authRoleMiddleware(), userController.updateInfo);
router.post("/report", authRoleMiddleware(), userController.reportUser);
router.post("/forget-password", authOtpMiddleware(), userController.forgotPassword);
router.post("/get-info", authRoleMiddleware(), userController.getInfo);
router.post("/get-list", authRoleMiddleware(ROLE.ADMIN), userController.getListUser);
router.post("/get-list-block", authRoleMiddleware(ROLE.ADMIN), userController.getListBlock);

module.exports = router;
