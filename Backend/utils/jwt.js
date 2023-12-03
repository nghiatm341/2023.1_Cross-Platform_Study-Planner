const jwt = require("jsonwebtoken");

const secret = "shhhhhhhhhh";

exports.signToken = (data, time) => {
  return new Promise((resolve, reject) => {
    jwt.sign({ exp: Math.floor(Date.now() / 1000) + time, data }, secret, (err, token) => {
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
