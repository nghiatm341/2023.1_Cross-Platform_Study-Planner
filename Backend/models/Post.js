const mongoose = require('mongoose')
const Schema = mongoose.Schema

const PostSchema = new Schema({
    id: {
        type: Number,
        require: true
    },

    title: {
        type: String,
        default: ""
    },
    content: {
        type: String,
        default: ""
    },
    image: {
        type: String,
        default: ""
    },
    list_like: [
        {
            user: {
                type: Number,
                default: 0
            },
            created_at: {
                type: Date,
                default: Date.now()
            }
        }
    ],
    list_comment: [
        {
            user: {
                type: Number,
                default: 0
            },
            comment: {
                type: String,
                default: ""
            },
            created_at: {
                type: Date,
                default: Date.now()
            }
        }
    ],
    user: {
        type: Number,
        require: true,
        default: 0
    },

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
}, {
    timestamps: true,
    versionKey: false,
    collection: "Post"
})

module.exports = mongoose.model("Post", PostSchema)