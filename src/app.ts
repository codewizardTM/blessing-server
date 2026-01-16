import express from "express";
import { blessings } from "./blessing";

const app = express();
const port = 3000;

app.get("/api/blessing", (req, res) => {
  const text = blessings[Math.floor(Math.random() * blessings.length)];

  res.json({
    text,
    time: Date.now(),
  });
});

app.listen(port, () => {
  console.log(`🚀 server running at http://localhost:${port}`);
});
