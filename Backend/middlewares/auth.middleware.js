const User = require("../models/user");
const { verifyToken } = require("../utils/jwt");

exports.authRoleMiddleware = (...role) => {
  return (req, res, next) => {
    let token = req.headers.authorization?.replace("Bearer", "").trim();
    if (!token) {
      return res.status(400).json({
        message: "Token required",
      });
    }
    verifyToken(token)
      .then(async (data) => {
        const findUser = await User.findOne({ id: data.id });
        if (token !== findUser.token) {
          return res.status(400).json({ message: "Invalid token" });
        }
        if (role && !role.includes(data.role)) return res.status(403).json({ message: "Unauthorized" });
        req.userInfo = data;
        next();
      })
      .catch(() => res.status(400).json({ message: "Invalid token" }));
  };
};

exports.authOtpMiddleware = () => {
  return (req, res, next) => {
    let token = req.headers.authorization?.replace("Bearer", "").trim();
    if (!token) {
      return res.status(400).json({
        message: "Token required",
      });
    }
    verifyToken(token)
      .then(async (data) => {
        req.email = data.email;
        next();
      })
      .catch(() => res.status(400).json({ message: "Invalid token" }));
  };
};
