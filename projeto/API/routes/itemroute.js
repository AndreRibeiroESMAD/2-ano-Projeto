const express = require('express');
const { body } = require('express-validator');
const itemController = require('../controllers/itemcontroller');
const auth = require('../middleware/auth');

const router = express.Router();

//POST /api/items/add (protected)
router.post('/add', auth, itemController.add);

//GET /api/items/get (public - all items)
router.get('/get', itemController.get);

//GET /api/items/myitems (protected - user's items)
router.get('/myitems', auth, itemController.getMyItems);

//GET /api/items/get/:id
router.get('/get/:id', itemController.getitem);

//PUT /api/items/edit/:id (protected)
router.put('/edit/:id', auth, itemController.edit);

//DELETE /api/items/delete/:id (protected)
router.delete('/delete/:id', auth, itemController.deleteItem);

module.exports = router;