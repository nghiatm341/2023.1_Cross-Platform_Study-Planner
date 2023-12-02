const mongoose = require("mongoose");
const UserSchema = mongoose.Schema(
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
      unique: true,
    },

    firstName: {
      type: String,
      maxLength: 255,
      require: true,
    },

    lastName: {
      type: String,
      maxLength: 255,
      require: true,
    },

    password: {
      type: String,
      maxLength: 255,
      require: true,
    },

    token: {
      type: String,
      maxLength: 255,
      require: true,
    },

    refreshToken: {
      type: String,
      maxLength: 255,
      require: true,
    },

    dob: {
      type: Date,
      require: false,
    },

    phoneNumber: {
      type: String,
      maxLength: 15,
      require: false,
    },

    gender: {
      type: String,
      enum: ["male", "female", "other"],
      require: false,
    },

    role: {
      type: String,
      enum: ["admin", "student", "teacher"],
      require: true,
    },

    avatar: {
      type: String,
      default: "https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg",
    },

    score: {
      type: Number,
      default: 1000,
    },
    // Default
    is_delete: {
      type: Number,
      require: true,
      default: 0,
    },
    update_by: {
      type: Number,
      required: false,
    },
  },
  {
    timestamps: true,
    collection: "User",
  }
);

module.exports = mongoose.model("User", UserSchema);
