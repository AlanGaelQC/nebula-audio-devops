import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import analyticsRouter from "./routes/analytics.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const port = process.env.PORT || 3003;

app.get("/healthz", (req, res) => res.status(200).send("ok"));
app.use("/api/analytics", analyticsRouter);
app.get("/api/recommendations", (req, res) => {
  res.redirect(307, `/api/analytics/recommendations?${new URLSearchParams(req.query)}`);
});

app.listen(port, () => {
  console.log(`Analytics Service listening on 0.0.0.0:${port}`);
});
