import pg from "pg";

const { Pool } = pg;

export function createPool() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    // Modo laboratorio: si no hay DB, la API sigue funcionando con datos en memoria.
    return null;
  }
  return new Pool({ connectionString });
}

export async function ensureSchema(pool) {
  if (!pool) return;
  await pool.query(`
    CREATE TABLE IF NOT EXISTS items (
      id SERIAL PRIMARY KEY,
      text TEXT NOT NULL,
      created_at TIMESTAMP NOT NULL DEFAULT NOW()
    );
  `);
}
