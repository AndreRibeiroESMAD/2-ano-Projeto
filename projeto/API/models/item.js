const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const itemSchema = new mongoose.Schema({

    name: {
        type: String,
        required: true,
        trim: true
    },

    price: {
        type: Number,
        required: true,

    },

    description: {
        type: String,
        required: true,

    },

    rating: {
        type: Number,
        default: "0"
    }

},{
  timestamps: true
})



module.exports = mongoose.model('Item', itemSchema);