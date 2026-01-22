const express = require('express');
const { body } = require('express-validator');
const auth = require('../middleware/auth');
const cartController = require('../controllers/cartcontroller');

const router = express.Router();

// POST /api/cart/add
router.post('/add', auth, cartController.addtocart);

// GET /api/cart/get
router.get('/get', auth, cartController.getcart);

// DELETE /api/cart/delete
router.delete('/delete', auth, cartController.deleteitem);

// DELETE /api/cart/remove/:itemId
router.delete('/remove/:itemId', auth, cartController.removeItemFromCart);

module.exports = router;