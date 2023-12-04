const mongoose = require('mongoose')

const StudyRouteSchema = mongoose.Schema({

    routeId: {
        type: String,
        require: true
    },

    userId: {
        type: Number,
        require: true
    },

    courseId: {
        type: Number,
        require: true
    },

    createdAt: {
        type: Date,
        require: true
    },

    isFinished: {
        type: Boolean,
        require: true
    },

    finishedAt: {
        type: Date,
    },

    lessons: [{
        lessonId: {
            type: Number,
        },

        studyTime: {
            type: Number
        },

        isCompleted: {
            type: Boolean,
            default: false
        },
    }]

}, {
    timestamps: true,
    collection: "StudyRoute"
});

module.exports = mongoose.model('StudyRoute', StudyRouteSchema);