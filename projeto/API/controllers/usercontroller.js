const { validationResult } = require('express-validator');
const User = require('../models/user');
const jwt = require('jsonwebtoken');

const get = async (req, res) => { 
    try {
        const users = await User.find();

        res.json({ users });
    } catch (error) {

    }       

}

const getuser = async (req, res) => { 
    try {
        const userId = req.userId;
        const user = await User.findById(userId);  
        if (!user) {
            return res.status(404).json({ message: 'User não encontrado' });
        }else {
            res.json({ user });
        }
    } catch (error) {
        return res.status(401).json({ message: 'Token inválido' });
    }
}

module.exports = {
    get,
    getuser
}; 