import { Router } from "express";

const router = Router();

// Catálogo de tracks simulado en memoria (MVP)
const TRACKS = [
  { id: 1, title: "Episodio 1: Introducción a DevOps", author: "Tech Podcast", duration_s: 1840 },
  { id: 2, title: "Episodio 2: Contenedores con Docker", author: "Tech Podcast", duration_s: 2100 },
  { id: 3, title: "Episodio 3: Kubernetes en práctica", author: "Tech Podcast", duration_s: 2400 },
  { id: 4, title: "Episodio 4: CI/CD con GitHub Actions", author: "Tech Podcast", duration_s: 1920 },
];

// GET /api/audio/tracks
router.get("/tracks", (req, res) => {
  return res.status(200).json({ tracks: TRACKS });
});

// GET /api/audio/stream/:id
router.get("/stream/:id", (req, res) => {
  const id = Number.parseInt(req.params.id, 10);
  const track = TRACKS.find((t) => t.id === id);

  if (!track)
    return res.status(404).json({ error: "track_not_found" });

  const start = Date.now();

  // Simula latencia de entrega del audio
  const latency_ms = Date.now() - start;

  return res.status(200).json({
    track,
    stream: {
      status: "ok",
      latency_ms,
      bitrate_kbps: 128,
      format: "mp3",
      url: `/audio/files/${track.id}.mp3`,
    },
  });
});

export default router;
