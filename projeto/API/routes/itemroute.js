const express = require('express');
const { body } = require('express-validator');
const itemController = require('../controllers/itemcontroller');

const router = express.Router();

//POST /api/items/add

router.post('/add', itemController.add);

//GET /api/items/get
router.get('/get', itemController.get);

module.exports = router;