const mongoose = require("mongoose");
const ReportSchema = mongoose.Schema(
  {
    id: {
      type: Number,
      require: true,
      unique: true,
    },

    reporter_id: {
      type: Number,
      require: true,
    },

    reported_user_id: {
      type: Number,
      require: true,
    },
    
    // Default
    is_delete: {
      type: Number,
      require: true,
      default: 0,
    },
  },
  {
    timestamps: true,
    collection: "Report",
  }
);

module.exports = mongoose.model("Report", ReportSchema);
