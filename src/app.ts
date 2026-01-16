import express from "express";
import { blessings } from "./blessing";

const app = express();
const port = process.env.PORT || 3000;

const host = process.env.HOST || "0.0.0.0";

/** 健康检查 */
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok",
    time: Date.now(),
  });
});

/** 业务接口 */
app.get("/api/blessing", (req, res) => {
  const text = blessings[Math.floor(Math.random() * blessings.length)];

  res.json({
    text,
    time: Date.now(),
  });
});

app.listen(port as number, host, () => {
  console.log(`🚀 server running at http://localhost:${port}`);
});
