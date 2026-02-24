import { useState, useEffect } from "react";
import "./App.css";

const API = "/api";

const MUSIC = [
  { id: 101, title: "Neon Dreams", artist: "Synthwave Collective", duration_s: 214, emoji: "🌆", bg: "linear-gradient(135deg,#c026d3,#7c3aed)" },
  { id: 102, title: "Midnight Drive", artist: "Lo-Fi Harbor", duration_s: 187, emoji: "🌙", bg: "linear-gradient(135deg,#0891b2,#6d28d9)" },
  { id: 103, title: "Gravity", artist: "Electronic Pulse", duration_s: 243, emoji: "⚡", bg: "linear-gradient(135deg,#be123c,#c026d3)" },
  { id: 104, title: "Starfall", artist: "Ambient Project", duration_s: 198, emoji: "✨", bg: "linear-gradient(135deg,#065f46,#0891b2)" },
  { id: 105, title: "Echo Chamber", artist: "Deep Signal", duration_s: 221, emoji: "🔊", bg: "linear-gradient(135deg,#92400e,#c026d3)" },
  { id: 106, title: "Parallel Universe", artist: "Cosmic Audio", duration_s: 268, emoji: "🪐", bg: "linear-gradient(135deg,#1d4ed8,#7c3aed)" },
];

const PLAYLISTS = [
  { id: 201, name: "Top Hits", tracks: 24, emoji: "🔥", bg: "linear-gradient(135deg,#dc2626,#c026d3)" },
  { id: 202, name: "Lo-Fi Study", tracks: 18, emoji: "📚", bg: "linear-gradient(135deg,#0891b2,#065f46)" },
  { id: 203, name: "Pop Hits 2025", tracks: 32, emoji: "🎤", bg: "linear-gradient(135deg,#c026d3,#db2777)" },
  { id: 204, name: "Electronic", tracks: 15, emoji: "🎛️", bg: "linear-gradient(135deg,#7c3aed,#1d4ed8)" },
];

const fmt = (s) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
const initials = (name) => name?.split(" ").map(w => w[0]).join("").toUpperCase().slice(0, 2) || "U";

// ─── REGISTER ────────────────────────────────────────────────────────────────
function Register({ onGoLogin }) {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  async function handleRegister() {
    setError("");
    if (!name.trim() || !email.trim() || !password.trim()) { setError("Todos los campos son obligatorios"); return; }
    if (name.trim().length < 2) { setError("El nombre debe tener al menos 2 caracteres"); return; }
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email.trim())) { setError("Ingresa un correo electrónico válido"); return; }
    if (password.length < 6) { setError("La contraseña debe tener al menos 6 caracteres"); return; }
    setLoading(true);
    try {
      const res = await fetch(`${API}/auth/register`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ name: name.trim(), email: email.trim(), password }),
      });
      const data = await res.json();
      if (!res.ok) { setError(data.error === "email_already_registered" ? "Este correo ya está registrado" : "Error al crear la cuenta"); return; }
      setSuccess(true);
    } catch { setError("Error conectando con el servicio de autenticación"); }
    finally { setLoading(false); }
  }

  if (success) return (
    <div className="auth-screen">
      <div className="auth-box" style={{ textAlign: "center" }}>
        <div className="auth-logo">🎧 Nebula Audio</div>
        <div style={{ fontSize: "3rem", margin: "1rem 0" }}>✅</div>
        <p className="success-msg">¡Cuenta creada exitosamente!</p>
        <p style={{ color: "var(--muted)", fontSize: "0.85rem", marginBottom: "1.5rem" }}>Ya puedes iniciar sesión</p>
        <button className="btn-primary" onClick={onGoLogin}>Ir al Login</button>
      </div>
    </div>
  );

  return (
    <div className="auth-screen">
      <div className="auth-box">
        <div className="auth-logo">🎧 Nebula Audio</div>
        <p className="auth-subtitle">Crea tu cuenta gratuita</p>
        {error && <div className="error-msg">{error}</div>}
        <div className="input-group">
          <label className="input-label">Nombre completo</label>
          <input className="input-field" type="text" value={name} onChange={e => setName(e.target.value)} placeholder="Tu nombre" />
        </div>
        <div className="input-group">
          <label className="input-label">Correo electrónico</label>
          <input className="input-field" type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="correo@ejemplo.com" />
        </div>
        <div className="input-group">
          <label className="input-label">Contraseña</label>
          <input className="input-field" type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="Mínimo 6 caracteres" />
        </div>
        <button className="btn-primary" onClick={handleRegister} disabled={loading}>
          {loading ? "Creando cuenta..." : "Crear cuenta"}
        </button>
        <p className="auth-switch">¿Ya tienes cuenta? <span className="auth-link" onClick={onGoLogin}>Inicia sesión</span></p>
      </div>
    </div>
  );
}

// ─── LOGIN ────────────────────────────────────────────────────────────────────
function Login({ onLogin, onGoRegister }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleLogin() {
    setLoading(true); setError("");
    try {
      const res = await fetch(`${API}/auth/login`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ email, password }),
      });
      const data = await res.json();
      if (!res.ok) { setError("Credenciales inválidas"); return; }
      onLogin(data.token, data.user);
    } catch { setError("Error conectando con el servicio de autenticación"); }
    finally { setLoading(false); }
  }

  return (
    <div className="auth-screen">
      <div className="auth-box">
        <div className="auth-logo">🎧 Nebula Audio</div>
        <p className="auth-subtitle">Acceso unificado web y móvil · JWT</p>
        {error && <div className="error-msg">{error}</div>}
        <div className="input-group">
          <label className="input-label">Correo electrónico</label>
          <input className="input-field" type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="correo@ejemplo.com" />
        </div>
        <div className="input-group">
          <label className="input-label">Contraseña</label>
          <input className="input-field" type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="Tu contraseña" />
        </div>
        <button className="btn-primary" onClick={handleLogin} disabled={loading}>
          {loading ? "Autenticando..." : "Iniciar sesión"}
        </button>
        <p className="auth-switch">¿No tienes cuenta? <span className="auth-link" onClick={onGoRegister}>Regístrate gratis</span></p>
      </div>
    </div>
  );
}

// ─── SIDEBAR ─────────────────────────────────────────────────────────────────
function Sidebar({ user, section, onSection, onLogout }) {
  const nav = [
    { id: "home", icon: "🏠", label: "Inicio" },
    { id: "music", icon: "🎵", label: "Música" },
    { id: "podcasts", icon: "🎙️", label: "Podcasts" },
    { id: "library", icon: "📚", label: "Biblioteca" },
  ];
  return (
    <aside className="sidebar">
      <div className="sidebar-logo">🎧 Nebula</div>
      <div className="nav-section">
        <div className="nav-label">Menú</div>
        {nav.map(n => (
          <div key={n.id} className={`nav-item ${section === n.id ? "active" : ""}`} onClick={() => onSection(n.id)}>
            <span className="nav-icon">{n.icon}</span>
            {n.label}
          </div>
        ))}
      </div>
      <div className="sidebar-footer">
        <div className="user-pill">
          <div className="user-avatar">{initials(user.name)}</div>
          <div>
            <div className="user-name">{user.name}</div>
            <div className="user-plan">Plan Gratuito</div>
          </div>
        </div>
        <button className="btn-logout" onClick={onLogout}>Cerrar sesión</button>
      </div>
    </aside>
  );
}

// ─── HOME ─────────────────────────────────────────────────────────────────────
function Home({ user, onPlay, recs }) {
  return (
    <div>
      <div className="hero-banner">
        <div className="hero-tag">✦ Destacado esta semana</div>
        <div className="hero-title">Bienvenido, {user.name.split(" ")[0]}</div>
        <div className="hero-artist">Continúa donde lo dejaste · Nebula Audio</div>
        <button className="hero-play" onClick={() => onPlay(MUSIC[0])}>▶ Reproducir ahora</button>
      </div>

      <div className="section-header">
        <h2 className="section-title">Colecciones</h2>
      </div>
      <div className="cards-grid">
        {PLAYLISTS.map(p => (
          <div key={p.id} className="music-card" onClick={() => onPlay(MUSIC[0])}>
            <div className="card-cover" style={{ background: p.bg }}>
              <span>{p.emoji}</span>
              <div className="card-play-btn">▶</div>
            </div>
            <div className="card-title">{p.name}</div>
            <div className="card-sub">{p.tracks} canciones</div>
          </div>
        ))}
      </div>

      <div className="section-header">
        <h2 className="section-title">✨ Recomendaciones</h2>
        {recs?.source === "personalized" && (
          <span className="section-link">{recs.based_on_events} eventos registrados</span>
        )}
      </div>
      <div className="rec-grid">
        {(recs?.recommendations || []).map(r => (
          <div key={r.id} className="rec-card" onClick={() => onPlay(r)}>
            <div className="rec-thumb" style={{ background: "linear-gradient(135deg,#c026d3,#7c3aed)" }}>🎙️</div>
            <div>
              <div className="rec-reason">{r.reason}</div>
              <div className="rec-title">{r.title}</div>
              <div className="rec-artist">{r.author || "Tech Podcast"}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── MUSIC ────────────────────────────────────────────────────────────────────
function Music({ onPlay, current }) {
  return (
    <div>
      <div className="section-header">
        <h2 className="section-title">🎵 Música</h2>
      </div>
      <div className="cards-grid">
        {PLAYLISTS.map(p => (
          <div key={p.id} className="music-card" onClick={() => onPlay(MUSIC[0])}>
            <div className="card-cover" style={{ background: p.bg }}>
              <span>{p.emoji}</span>
              <div className="card-play-btn">▶</div>
            </div>
            <div className="card-title">{p.name}</div>
            <div className="card-sub">{p.tracks} canciones</div>
          </div>
        ))}
      </div>
      <div className="section-header">
        <h2 className="section-title">Canciones populares</h2>
      </div>
      <div className="track-list">
        {MUSIC.map((t, i) => (
          <div key={t.id} className={`track-row ${current?.id === t.id ? "active" : ""}`} onClick={() => onPlay(t)}>
            <div className="track-num">{current?.id === t.id ? "▶" : i + 1}</div>
            <div className="track-info-row">
              <div className="track-thumb" style={{ background: t.bg }}>{t.emoji}</div>
              <div>
                <div className="track-name">{t.title}</div>
                <div className="track-artist">{t.artist}</div>
              </div>
            </div>
            <div className="track-duration">{fmt(t.duration_s)}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── PODCASTS ─────────────────────────────────────────────────────────────────
function Podcasts({ onPlay, current, tracks }) {
  return (
    <div>
      <div className="section-header">
        <h2 className="section-title">🎙️ Podcasts</h2>
      </div>
      <div className="track-list">
        {tracks.map((t, i) => (
          <div key={t.id} className={`track-row ${current?.id === t.id ? "active" : ""}`} onClick={() => onPlay(t)}>
            <div className="track-num">{current?.id === t.id ? "▶" : i + 1}</div>
            <div className="track-info-row">
              <div className="track-thumb" style={{ background: "linear-gradient(135deg,#7c3aed,#0891b2)" }}>🎙️</div>
              <div>
                <div className="track-name">{t.title}</div>
                <div className="track-artist">{t.author} · {fmt(t.duration_s)}</div>
              </div>
            </div>
            <div className="track-duration">{fmt(t.duration_s)}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── LIBRARY ─────────────────────────────────────────────────────────────────
function Library({ onPlay, history }) {
  const favorites = MUSIC.slice(0, 3);
  const saved = MUSIC.slice(3, 6);
  return (
    <div>
      {history.length > 0 && (
        <>
          <div className="section-header">
            <h2 className="section-title">🕐 Reproducidos recientemente</h2>
          </div>
          <div className="library-list">
            {history.slice(0, 5).map((t, i) => (
              <div key={i} className="library-item" onClick={() => onPlay(t)}>
                <div className="library-thumb" style={{ background: t.bg || "linear-gradient(135deg,#7c3aed,#0891b2)" }}>{t.emoji || "🎙️"}</div>
                <div className="library-info">
                  <div className="library-name">{t.title}</div>
                  <div className="library-meta">{t.artist || t.author}</div>
                </div>
                <span className="library-badge">Reciente</span>
              </div>
            ))}
          </div>
        </>
      )}
      <div className="section-header">
        <h2 className="section-title">❤️ Favoritos</h2>
      </div>
      <div className="library-list">
        {favorites.map(t => (
          <div key={t.id} className="library-item" onClick={() => onPlay(t)}>
            <div className="library-thumb" style={{ background: t.bg }}>{t.emoji}</div>
            <div className="library-info">
              <div className="library-name">{t.title}</div>
              <div className="library-meta">{t.artist}</div>
            </div>
            <span className="library-badge">❤️ Guardado</span>
          </div>
        ))}
      </div>
      <div className="section-header" style={{ marginTop: "1.5rem" }}>
        <h2 className="section-title">🔖 Guardados</h2>
      </div>
      <div className="library-list">
        {saved.map(t => (
          <div key={t.id} className="library-item" onClick={() => onPlay(t)}>
            <div className="library-thumb" style={{ background: t.bg }}>{t.emoji}</div>
            <div className="library-info">
              <div className="library-name">{t.title}</div>
              <div className="library-meta">{t.artist}</div>
            </div>
            <span className="library-badge">🔖</span>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── PLAYER BAR ───────────────────────────────────────────────────────────────
function PlayerBar({ current, latency }) {
  const [playing, setPlaying] = useState(true);
  const [progressKey, setProgressKey] = useState(0);
  useEffect(() => { setPlaying(true); setProgressKey(k => k + 1); }, [current]);
  if (!current) return null;
  return (
    <div className="player-bar">
      <div className="player-track">
        <div className={`player-thumb ${playing ? "playing" : ""}`}
          style={{ background: current.bg || "linear-gradient(135deg,#7c3aed,#0891b2)" }}>
          {current.emoji || "🎙️"}
        </div>
        <div>
          <div className="player-track-name">{current.title}</div>
          <div className="player-track-artist">{current.artist || current.author}</div>
        </div>
      </div>
      <div className="player-controls">
        <div className="player-buttons">
          <button className="ctrl-btn">⏮</button>
          <button className="play-btn" onClick={() => setPlaying(p => !p)}>{playing ? "⏸" : "▶"}</button>
          <button className="ctrl-btn">⏭</button>
        </div>
        <div className="progress-container">
          <span className="progress-time">0:00</span>
          <div className="progress-bar">
            {playing && <div key={progressKey} className="progress-fill" />}
          </div>
          <span className="progress-time">{fmt(current.duration_s || 0)}</span>
        </div>
      </div>
      <div className="player-metrics">
        <div className="metric-badge">
          📡 Latencia: <span className={latency <= 10 ? "metric-good" : "metric-warn"}>{latency ?? "—"}ms</span>
        </div>
        <div className="metric-badge">🔒 JWT activo</div>
      </div>
    </div>
  );
}

// ─── DASHBOARD ────────────────────────────────────────────────────────────────
function Dashboard({ user, onLogout }) {
  const [section, setSection] = useState("home");
  const [current, setCurrent] = useState(null);
  const [latency, setLatency] = useState(null);
  const [recs, setRecs] = useState(null);
  const [podTracks, setPodTracks] = useState([]);
  const [history, setHistory] = useState([]);

  useEffect(() => {
    fetch(`${API}/audio/tracks`).then(r => r.json()).then(d => setPodTracks(d.tracks || []));
    fetch(`${API}/recommendations?user_id=${user.id}`).then(r => r.json()).then(setRecs);
  }, []);

  async function handlePlay(track) {
    setCurrent(track);
    setLatency(null);
    setHistory(h => [track, ...h.filter(t => t.id !== track.id)].slice(0, 10));
    if (track.id <= 10) {
      const res = await fetch(`${API}/audio/stream/${track.id}`);
      const data = await res.json();
      setLatency(data.stream?.latency_ms ?? 0);
      await fetch(`${API}/analytics/event`, {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ user_id: user.id, track_id: track.id, action: "play", listened_seconds: 0 }),
      });
      const updated = await fetch(`${API}/recommendations?user_id=${user.id}`);
      setRecs(await updated.json());
    } else {
      setLatency(Math.floor(Math.random() * 12) + 2);
    }
  }

  return (
    <div className="app-layout">
      <Sidebar user={user} section={section} onSection={setSection} onLogout={onLogout} />
      <main className="main-content">
        {section === "home" && <Home user={user} onPlay={handlePlay} recs={recs} />}
        {section === "music" && <Music onPlay={handlePlay} current={current} />}
        {section === "podcasts" && <Podcasts onPlay={handlePlay} current={current} tracks={podTracks} />}
        {section === "library" && <Library onPlay={handlePlay} history={history} />}
      </main>
      <PlayerBar current={current} latency={latency} />
    </div>
  );
}

// ─── APP ──────────────────────────────────────────────────────────────────────
export default function App() {
  const [view, setView] = useState("login");
  const [token, setToken] = useState(null);
  const [user, setUser] = useState(null);

  function handleLogin(t, u) { setToken(t); setUser(u); setView("dashboard"); }
  function handleLogout() { setToken(null); setUser(null); setView("login"); }

  if (view === "register") return <Register onGoLogin={() => setView("login")} />;
  if (view === "login") return <Login onLogin={handleLogin} onGoRegister={() => setView("register")} />;
  if (view === "dashboard" && token) return <Dashboard user={user} onLogout={handleLogout} />;
  return <Login onLogin={handleLogin} onGoRegister={() => setView("register")} />;
}
