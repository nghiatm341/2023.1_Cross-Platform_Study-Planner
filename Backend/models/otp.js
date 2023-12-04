const mongoose = require("mongoose");
const OtpSchema = mongoose.Schema(
  {
    id: {
      type: Number,
      require: true,
      unique: true,
    },
    email: {
      type: String,
      maxLength: 255,
      require: true,
    },

    otp: {
      type: Number,
      require: true,
    },
    expireAt: {
      type: Date,
      require: true,
    },
    is_delete: {
      type: Number,
      require: true,
      default: 0,
    },
  },
  {
    timestamps: true,
    collection: "Otp",
  }
);

module.exports = mongoose.model("Otp", OtpSchema);
