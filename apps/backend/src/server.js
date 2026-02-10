import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { createPool, ensureSchema } from "./db.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const port = process.env.PORT || 3000;

let memItems = [{ id: 1, text: "Hello FinLab", created_at: new Date().toISOString() }];

const pool = createPool();
if (pool) {
  pool.on("error", (err) => console.error("Postgres pool error:", err));
  ensureSchema(pool).catch((e) => console.error("ensureSchema error:", e));
}

async function dbOk() {
  if (!pool) return true; // Modo sin DB: considerado listo
  const res = await pool.query("SELECT 1 AS ok");
  return res?.rows?.[0]?.ok === 1;
}

app.get("/healthz", (req, res) => res.status(200).send("ok"));

app.get("/readyz", async (req, res) => {
  try {
    const ok = await dbOk();
    return ok ? res.status(200).send("ready") : res.status(503).send("not ready");
  } catch (e) {
    return res.status(503).send("not ready");
  }
});

app.get("/api/items", async (req, res) => {
  try {
    if (!pool) return res.json(memItems);
    const { rows } = await pool.query("SELECT id, text, created_at FROM items ORDER BY id DESC LIMIT 200");
    return res.json(rows);
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: "db_error" });
  }
});

app.post("/api/items", async (req, res) => {
  const text = String(req.body?.text || "").trim();
  if (!text) return res.status(400).json({ error: "text_required" });

  try {
    if (!pool) {
      const nextId = (memItems[0]?.id || 0) + 1;
      const item = { id: nextId, text, created_at: new Date().toISOString() };
      memItems = [item, ...memItems];
      return res.status(201).json(item);
    }
    const { rows } = await pool.query(
      "INSERT INTO items(text) VALUES($1) RETURNING id, text, created_at",
      [text]
    );
    return res.status(201).json(rows[0]);
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: "db_error" });
  }
});

app.listen(port, () => {
  console.log(`API listening on 0.0.0.0:${port}`);
});
