const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const cartSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  },
  items: [{
    itemId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Item',
      required: true
    }
  }]
}, {
  timestamps: true
})

module.exports = mongoose.model('Cart', cartSchema);
