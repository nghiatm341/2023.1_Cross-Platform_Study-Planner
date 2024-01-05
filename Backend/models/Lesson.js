const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const LessonSchema = new Schema({
    id: {
        type: Number,
        require: true
    },

    title: {
        type: String,
        default: ""
    },
    contents: [{
        contents: {
            type: String,
            default: ""
        },
        content_type: { // 1 String, 2 Image
            type: Number,
            default: 1
        }
    }],
    chapter_title: {
        type: String,
        default: ""
    },
    course_id: {
        type: Number,
        require: true
    },
    estimate_time: { // Hour
        type: Number,
        default: 0
    },
    lesson_before_id: [{
        type: Number,
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
    collection: "Lesson"
})

module.exports = mongoose.model('Lesson', LessonSchema)