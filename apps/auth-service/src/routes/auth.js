import { Router } from "express";
import jwt from "jsonwebtoken";

const router = Router();
const JWT_SECRET = process.env.JWT_SECRET || "podcast_secret_dev";

// Usuarios simulados en memoria (MVP)
let USERS = [
  { id: 1, email: "user@podcast.com", password: "1234", name: "Alan" },
  { id: 2, email: "test@podcast.com", password: "abcd", name: "Erick" },
];

// POST /api/auth/register
router.post("/register", (req, res) => {
  const { email, password, name } = req.body || {};

  if (!email || !password || !name)
    return res.status(400).json({ error: "name_email_and_password_required" });

  const exists = USERS.find((u) => u.email === email);
  if (exists)
    return res.status(409).json({ error: "email_already_registered" });

  const newUser = { id: USERS.length + 1, email, password, name };
  USERS.push(newUser);

  return res.status(201).json({
    registered: true,
    user: { id: newUser.id, email: newUser.email, name: newUser.name },
  });
});

// POST /api/auth/login
router.post("/login", (req, res) => {
  const { email, password } = req.body || {};

  if (!email || !password)
    return res.status(400).json({ error: "email_and_password_required" });

  const user = USERS.find((u) => u.email === email && u.password === password);

  if (!user)
    return res.status(401).json({ error: "invalid_credentials" });

  const token = jwt.sign(
    { id: user.id, email: user.email, name: user.name },
    JWT_SECRET,
    { expiresIn: "2h" }
  );

  return res.status(200).json({
    token,
    user: { id: user.id, email: user.email, name: user.name },
  });
});

// GET /api/auth/verify
router.get("/verify", (req, res) => {
  const authHeader = req.headers.authorization || "";
  const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;

  if (!token)
    return res.status(401).json({ error: "token_required" });

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    return res.status(200).json({ valid: true, user: decoded });
  } catch {
    return res.status(401).json({ valid: false, error: "invalid_or_expired_token" });
  }
});

export default router;
