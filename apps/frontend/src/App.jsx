import React, { useEffect, useState } from "react";

const API_BASE = import.meta.env.VITE_API_BASE_URL || "/api";

export default function App() {
  const [items, setItems] = useState([]);
  const [text, setText] = useState("");
  const [status, setStatus] = useState("");

  async function load() {
    const res = await fetch(`${API_BASE}/items`);
    const data = await res.json();
    setItems(data);
  }

  async function add() {
    setStatus("saving...");
    const res = await fetch(`${API_BASE}/items`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ text })
    });
    if (!res.ok) {
      setStatus("error");
      return;
    }
    setText("");
    setStatus("ok");
    await load();
  }

  useEffect(() => { load(); }, []);

  return (
    <div style={{ fontFamily: "system-ui", padding: 24, maxWidth: 800 }}>
      <h1>FinLab DevOps</h1>
      <p>Objetivo: practicar contenedores, Kubernetes, Helm, CI/CD, pruebas e IaC.</p>

      <div style={{ display: "flex", gap: 8 }}>
        <input
          aria-label="new-item"
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder="Nuevo item..."
          style={{ flex: 1, padding: 8 }}
        />
        <button onClick={add} disabled={!text.trim()}>Agregar</button>
      </div>

      <div style={{ marginTop: 8, color: "#444" }}>{status}</div>

      <h2 style={{ marginTop: 24 }}>Items</h2>
      <ul>
        {items.map((it) => (
          <li key={it.id}><strong>#{it.id}</strong> {it.text}</li>
        ))}
      </ul>
    </div>
  );
}
