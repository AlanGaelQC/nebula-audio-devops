import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import authRouter from "./routes/auth.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const port = process.env.PORT || 3001;

app.get("/healthz", (req, res) => res.status(200).send("ok"));
app.use("/api/auth", authRouter);

app.listen(port, () => {
  console.log(`Auth Service listening on 0.0.0.0:${port}`);
});
