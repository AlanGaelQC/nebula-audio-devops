# scripts/07_fix_permissions.sh
#!/usr/bin/env bash
set -euo pipefail

fail() { echo "ERROR: $*" >&2; exit 1; }
warn() { echo "WARN: $*" >&2; }
ok()   { echo "OK: $*"; }

echo "== Finlab: fix permissions / docker access =="

# Si ya funciona sin sudo, no hacer nada
if docker ps >/dev/null 2>&1; then
  ok "Docker ya funciona sin sudo. No se requiere fix."
  exit 0
fi

echo
echo "Docker no funciona sin sudo. Intentaré corregir el caso Linux/WSL con Docker Engine."
echo "Si usas Docker Desktop, este script no puede habilitar la integración WSL por ti; te diré qué hacer."
echo

# Detectar Docker Desktop (heurístico) vs Docker Engine
# (No es perfecto, pero ayuda a orientar)
DOCKER_INFO="$(docker info 2>/dev/null || true)"
if echo "$DOCKER_INFO" | grep -qi "Docker Desktop"; then
  warn "Parece que estás usando Docker Desktop."
  echo
  echo "Acción recomendada (manual, en Windows):"
  echo "  1) Abre Docker Desktop"
  echo "  2) Settings > Resources > WSL Integration"
  echo "  3) Activa integración para tu distro (Ubuntu)"
  echo "  4) Apply & Restart"
  echo "  5) En WSL: cierra y abre terminal (o ejecuta: wsl.exe --shutdown desde PowerShell)"
  echo
  exit 1
fi

# Caso Docker Engine dentro de WSL
echo "Aplicando fix: grupo docker + agregar usuario actual."
echo "(Necesitará sudo una sola vez.)"
echo

# Crear grupo docker si no existe
if getent group docker >/dev/null 2>&1; then
  ok "Grupo docker ya existe"
else
  sudo groupadd docker
  ok "Grupo docker creado"
fi

# Agregar usuario actual al grupo docker
sudo usermod -aG docker "$USER"
ok "Usuario '$USER' agregado al grupo docker"

echo
echo "IMPORTANTE:"
echo "  Para que el cambio tome efecto, necesitas reiniciar sesión de shell."
echo "  Opciones:"
echo "    A) Ejecuta: newgrp docker"
echo "    B) Cierra y abre tu terminal WSL"
echo "    C) Desde PowerShell: wsl.exe --shutdown (y vuelve a abrir WSL)"
echo

# Intento inmediato (a veces funciona)
set +e
newgrp docker <<'EOF'
docker ps >/dev/null 2>&1
EOF
RES=$?
set -e

if [ "$RES" -eq 0 ]; then
  ok "Docker ahora funciona sin sudo (en esta sesión)."
else
  warn "Docker todavía no funciona en esta sesión. Reinicia WSL/terminal y vuelve a probar:"
  echo "  docker ps"
fi
