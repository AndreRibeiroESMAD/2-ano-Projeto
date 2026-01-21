const express = require('express');
const { body } = require('express-validator');
const userController = require('../controllers/usercontroller');
const auth = require('../middleware/auth');

const router = express.Router();

//GET /api/users/get
router.get('/get', auth, userController.get);

//GET /api/users/getuser (uses token from Authorization header)
router.get('/getuser', auth, userController.getuser);

module.exports = router;