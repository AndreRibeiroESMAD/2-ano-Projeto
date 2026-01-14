const mqtt = require('mqtt');

let client = null;

const connectMQTT = () => {
  client = mqtt.connect(process.env.MQTT_BROKER_URL);

  client.on('connect', () => {
    console.log('MQTT conectado com sucesso');

    // Exemplo: subscrever a um tópico
    client.subscribe('api-base/tasks', (err) => {
      if (!err) {
        console.log('Subscrito ao tópico: api-base/tasks');
      }
    });
  });

  client.on('message', (topic, message) => {
    // Exemplo: processar mensagens recebidas
    console.log(`Mensagem recebida no tópico ${topic}: ${message.toString()}`);
  });

  client.on('error', (error) => {
    console.error('Erro MQTT:', error.message);
  });

  return client;
};

const getClient = () => client;

const publish = (topic, message) => {
  if (client && client.connected) {
    client.publish(topic, JSON.stringify(message));
    console.log(`Mensagem publicada no tópico ${topic}`);
  }
};

module.exports = { connectMQTT, getClient, publish };
