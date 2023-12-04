const isValidDateTime = (dateTimeString) => {
  const dateTimeRegex = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$/;
  return dateTimeRegex.test(dateTimeString);
};

const isValidPhoneNumber = (phoneNumber) => {
  const regex = /^0[1-9]\d{8}$/;
  return regex.test(phoneNumber);
};

const isValidateEmail = (email) => {
  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  return emailRegex.test(email);
};

module.exports = { isValidateEmail, isValidDateTime, isValidPhoneNumber };
