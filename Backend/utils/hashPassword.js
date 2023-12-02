const bcrypt = require("bcrypt");
const saltRounds = 10;

exports.cryptPassword = (password) => {
  return new Promise((resolve, reject) => {
    bcrypt.genSalt(saltRounds, (err, salt) => {
      if (err) return reject(err);

      bcrypt.hash(password, salt, (err, hash) => {
        if (err) return reject(err);
        resolve(hash);
      });
    });
  });
};

exports.comparePassword = (plainPassword, hashPassword) => {
  return new Promise((resolve, reject) => {
    bcrypt.compare(plainPassword, hashPassword, (err, isPasswordMatch) => {
      if (err) return reject(err);
      return resolve(isPasswordMatch);
    });
  });
};
