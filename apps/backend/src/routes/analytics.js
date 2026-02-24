import { Router } from "express";

const router = Router();

// Eventos de comportamiento simulados en memoria (MVP)
let events = [];

// Catálogo base para recomendaciones sin historial
const BASE_RECOMMENDATIONS = [
  { id: 2, title: "Episodio 2: Contenedores con Docker", author: "Tech Podcast", reason: "Popular esta semana" },
  { id: 3, title: "Episodio 3: Kubernetes en práctica", author: "Tech Podcast", reason: "Tendencia en la plataforma" },
  { id: 4, title: "Episodio 4: CI/CD con GitHub Actions", author: "Tech Podcast", reason: "Recomendado para ti" },
];

// POST /api/analytics/event
router.post("/event", (req, res) => {
  const { user_id, track_id, action, listened_seconds } = req.body || {};

  if (!user_id || !track_id || !action)
    return res.status(400).json({ error: "user_id_track_id_and_action_required" });

  const event = {
    id: events.length + 1,
    user_id,
    track_id,
    action, // "play", "pause", "complete"
    listened_seconds: listened_seconds || 0,
    recorded_at: new Date().toISOString(),
  };

  events.push(event);

  return res.status(201).json({ recorded: true, event });
});

// GET /api/recommendations
router.get("/recommendations", (req, res) => {
  const { user_id } = req.query;

  if (!user_id)
    return res.status(200).json({ recommendations: BASE_RECOMMENDATIONS, source: "generic" });

  // Tracks que el usuario ya escuchó
  const listenedIds = new Set(
    events.filter((e) => String(e.user_id) === String(user_id)).map((e) => e.track_id)
  );

  if (listenedIds.size === 0)
    return res.status(200).json({ recommendations: BASE_RECOMMENDATIONS, source: "generic" });

  // Recomienda tracks que el usuario NO ha escuchado aún
  const personalized = BASE_RECOMMENDATIONS.filter((r) => !listenedIds.has(r.id));

  return res.status(200).json({
    recommendations: personalized.length > 0 ? personalized : BASE_RECOMMENDATIONS,
    source: "personalized",
    based_on_events: listenedIds.size,
  });
});

export default router;
