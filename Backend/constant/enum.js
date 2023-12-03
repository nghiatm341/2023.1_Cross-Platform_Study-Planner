const ROLE = {
  ADMIN: "admin",
  STUDENT: "student",
  TEACHER: "teacher",
};

const GENDER = {
  MALE: "male",
  FEMALE: "female",
  OTHER: "other",
};

const STATUS = {
  ACTIVE: "active",
  BLOCK: "block",
};

const REASON_REPORT = {
  SPAM: "Spam or Unwanted Content", //-50 score
  COPYRIGHT_VIOLATION: "Copyright Violation", //-100 score
  FRAUDULENT_OR_CHEATING: "Fraudulent or Cheating Behavior", //-100 score
  INAPPROPRIATE_OR_OFFENSIVE: "Inappropriate or Offensive Content", //-100 score
  HARASSMENT_OR_THREATENING: "Harassment or Threatening Behavior", //-250 score
};

module.exports = { ROLE, GENDER, REASON_REPORT, STATUS };
