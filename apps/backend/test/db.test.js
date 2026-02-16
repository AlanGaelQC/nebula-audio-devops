import test from "node:test";
import assert from "node:assert/strict";
import { isMemoryMode, resolvePoolOptions } from "../src/db.js";

test("resolvePoolOptions uses DATABASE_URL when present", () => {
  const opts = resolvePoolOptions({ DATABASE_URL: "postgresql://u:p@db:5432/app" });
  assert.deepEqual(opts, { connectionString: "postgresql://u:p@db:5432/app" });
});

test("resolvePoolOptions uses local defaults without env", () => {
  const opts = resolvePoolOptions({});
  assert.deepEqual(opts, {
    host: "localhost",
    port: 5432,
    user: "finlab",
    password: "finlab",
    database: "finlab",
  });
});

test("resolvePoolOptions supports DB_* fields", () => {
  const opts = resolvePoolOptions({
    DB_HOST: "postgres",
    DB_PORT: "5544",
    DB_USER: "service_user",
    DB_PASSWORD: "secret",
    DB_NAME: "service_db",
  });

  assert.deepEqual(opts, {
    host: "postgres",
    port: 5544,
    user: "service_user",
    password: "secret",
    database: "service_db",
  });
});

test("resolvePoolOptions supports POSTGRES_* aliases", () => {
  const opts = resolvePoolOptions({
    POSTGRES_HOST: "postgres-service",
    POSTGRES_PORT: "6432",
    POSTGRES_USER: "postgres_user",
    POSTGRES_PASSWORD: "postgres_pass",
    POSTGRES_DB: "postgres_db",
  });

  assert.deepEqual(opts, {
    host: "postgres-service",
    port: 6432,
    user: "postgres_user",
    password: "postgres_pass",
    database: "postgres_db",
  });
});

test("memory mode is explicit", () => {
  assert.equal(isMemoryMode({}), false);
  assert.equal(isMemoryMode({ DB_MODE: "memory" }), true);
  assert.equal(isMemoryMode({ DB_MODE: "postgres" }), false);
});
