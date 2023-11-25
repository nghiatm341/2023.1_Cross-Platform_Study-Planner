const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const CourseSchema = new Schema({
    id: {
        type: Number,
        require: true
    },

    title: {
        type: String,
        default: ""
    },
    description: {
        type: String,
        default: ""
    },
    author_id: {
        type: Number,
        require: true
    },
    lessons: [{
        type: Number,
        require: true,
        default: 0
    }],

    // Default
    is_delete: {
        type: Number,
        require: true,
        default: 0
    },
    create_at: {
        type: Date,
        require: true
    },
    update_at: {
        type: Date,
        require: true
    },
    user_id: {
        type: Number,
        require: true
    }
}, {
    timestamps: true,
    versionKey: false,
    collection: "Course"
})