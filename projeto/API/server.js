require('dotenv').config();

const express = require('express');
const authRoutes = require('./routes/authroute');
const itemRoutes = require('./routes/itemroute');
const userRoutes = require('./routes/userroutes');
const connectDB = require('./config/database');
const { connectMQTT } = require('./config/mqtt');


const app = express();
app.use(express.json());

// Registrar todas as rotas ANTES de iniciar o servidor
app.use('/api/auth', authRoutes);
app.use('/api/items', itemRoutes);
app.use('/api/users', userRoutes);

const PORT = process.env.PORT || 3000;

// Iniciar servidor
const start = async () => {
  await connectDB();
  // await connectMQTT();

  app.listen(PORT, () => {
    console.log(`Servidor a correr na porta ${PORT}`);
  });
};

start();