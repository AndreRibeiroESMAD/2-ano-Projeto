const express = require('express');
const { body } = require('express-validator');
const authController = require('../controllers/authcontroller');
const auth = require('../middleware/auth');

const router = express.Router();

// Validações para register e login
const authValidation = [
  body('email').isEmail().withMessage('Email inválido'),
  body('password').isLength({ min: 6 }).withMessage('Password deve ter no mínimo 6 caracteres')
];

// POST /api/auth/register
router.post('/register', authValidation, authController.register);

// POST /api/auth/login
router.post('/login', authValidation, authController.login);

module.exports = router;