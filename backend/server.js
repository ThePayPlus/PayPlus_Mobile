// backend/server.js
const express = require('express');
const app = express();
const cors = require('cors');
const port = 3000;

// Enable CORS for Flutter
app.use(cors());
app.use(express.json());

// API endpoint
app.post('/api/chat', (req, res) => {
  const userMessage = req.body.message;

  // Sample logic to respond back
  const botResponse = `Bot response to: ${userMessage}`;

  res.json({ response: botResponse });
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
