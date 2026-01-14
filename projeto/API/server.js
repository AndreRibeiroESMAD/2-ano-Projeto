require('dotenv').config();

const express = require('express');
const authRoutes = require('./routes/authroute');
//const userRoutes = require('./routes/user');
const connectDB = require('./config/database');
const { connectMQTT } = require('./config/mqtt');


const app = express();
app.use(express.json())


const PORT = process.env.PORT || 3000;

app.use('/api/auth', authRoutes);

// Iniciar servidor
const start = async () => {
  await connectDB();
  // await connectMQTT();

  app.listen(PORT, () => {
    console.log(`Servidor a correr na porta ${PORT}`);
  });
};

start();