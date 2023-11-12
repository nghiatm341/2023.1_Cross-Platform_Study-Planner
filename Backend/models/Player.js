const mongoose = require('mongoose')
const playerSchema = mongoose.Schema({
    name: { type: String, maxLength: 255, require: true },
    level: { type: Number, require: true }

},
    {
        timestamps: true
    }
)

module.exports = mongoose.model('player', playerSchema);