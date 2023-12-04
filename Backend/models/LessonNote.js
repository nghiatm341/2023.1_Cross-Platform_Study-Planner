const mongoose = require('mongoose')

const LessonNoteSchema = mongoose.Schema({
    noteId: {
        type: String,
        require: true
    },

    routeId:{
        type: String,
        require: true
    },

    lessonId: {
        type: Number,
        require: true
    },

    content: {
        type: String,
        require: true
    }
}, {
    timestamps: true,
    versionKey: false,
    collection: "LessonNote"
});

module.exports = mongoose.model('LessonNote', LessonNoteSchema);