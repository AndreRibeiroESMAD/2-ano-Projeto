const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('Conectado à base de dados MongoDB');
  } catch (error) {
    console.error('Erro ao conectar à base de dados:', error);
    process.exit(1);
  }
};

module.exports = connectDB