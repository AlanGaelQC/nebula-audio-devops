import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import audioRouter from "./routes/audio.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const port = process.env.PORT || 3002;

app.get("/healthz", (req, res) => res.status(200).send("ok"));
app.use("/api/audio", audioRouter);

app.listen(port, () => {
  console.log(`Audio Service listening on 0.0.0.0:${port}`);
});
