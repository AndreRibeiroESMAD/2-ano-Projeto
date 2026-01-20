const express = require('express');
const { body } = require('express-validator');
const userController = require('../controllers/usercontroller');

const router = express.Router();

//GET /api/users/get
router.get('/get', userController.get);

//GET /api/users/getuser (uses token from Authorization header)
router.get('/getuser', userController.getuser);

module.exports = router;