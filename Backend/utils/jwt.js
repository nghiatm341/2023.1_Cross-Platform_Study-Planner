const jwt = require("jsonwebtoken");

const secret = "shhhhhhhhhh";

exports.signToken = (data) => {
  return new Promise((resolve, reject) => {
    jwt.sign({ exp: Math.floor(Date.now() / 1000) + 24 * 60 * 60, data }, secret, (err, token) => {
      if (err) return reject(err);
      return resolve(token);
    });
  });
};

exports.verifyToken = (token) => {
  return new Promise((resolve, reject) => {
    jwt.verify(token, secret, (err, decode) => {
      if (err) return reject(err);
      return resolve(decode.data);
    });
  });
};
