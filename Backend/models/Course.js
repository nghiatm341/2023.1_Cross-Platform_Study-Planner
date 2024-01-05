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
    lessons: [
        {
            lesson: {
                type: Number,
                require: true,
                default: 0
            }
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
    },

    is_drafting: {
        type: Number,
        default: 1
    },
    list_subscriber: [{
        user_id: {
            type: Number,
            default: 0
        }
    }],
    avatar: {
        type: String,
        default: ''
    },
}, {
    timestamps: true,
    versionKey: false,
    collection: "Course"
})

module.exports = mongoose.model('Course', CourseSchema)