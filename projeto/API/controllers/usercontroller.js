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
        const token = req.headers.authorization?.split(' ')[1];
        
        if (!token) {
            return res.status(401).json({ message: 'Token não fornecido' });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your_secret_key');
        const userId = decoded.userId || decoded.id;
        
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