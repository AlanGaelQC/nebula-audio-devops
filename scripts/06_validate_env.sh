# scripts/06_validate_env.sh
#!/usr/bin/env bash
set -euo pipefail

fail() { echo "ERROR: $*" >&2; exit 1; }
warn() { echo "WARN: $*" >&2; }
ok()   { echo "OK: $*"; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Falta herramienta: $1"
}

echo "== Finlab: validate environment =="

# 1) Validar que estás en WSL/Linux
if grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null; then
  ok "WSL detectado"
else
  warn "No parece ser WSL. Este laboratorio está estandarizado para Windows+WSL2."
fi

# 2) Validar que estás en la raíz del repo
[ -d "apps" ]    || fail "No existe ./apps. Ejecuta desde la raíz del repo (donde está apps/ infra/ scripts/)."
[ -d "infra" ]   || fail "No existe ./infra. Ejecuta desde la raíz del repo."
[ -d "scripts" ] || fail "No existe ./scripts. Ejecuta desde la raíz del repo."
ok "Estructura del repo OK"

# 3) Herramientas principales
need_cmd git
need_cmd docker
need_cmd kubectl
need_cmd helm
need_cmd k3d
command -v node >/dev/null 2>&1 || warn "node no encontrado (opcional si solo build/deploy via Docker)."
ok "Herramientas DevOps principales OK"

# 4) Herramientas del temario (opcionales según evaluación, pero recomendadas)
command -v terraform >/dev/null 2>&1 || warn "terraform no encontrado (IaC). Instalar para completar Actividad 4."
command -v ansible   >/dev/null 2>&1 || warn "ansible no encontrado (automatización). Instalar para completar Actividad 4."
command -v k6        >/dev/null 2>&1 || warn "k6 no encontrado (prueba carga + evidencia HPA). Instalar para completar Actividad 4."
command -v curl      >/dev/null 2>&1 || warn "curl no encontrado (recomendado para validaciones rápidas)."

# 5) Docker daemon accesible SIN sudo (requisito para automatización)
if docker ps >/dev/null 2>&1; then
  ok "Docker daemon accesible sin sudo"
else
  warn "Docker NO responde sin sudo."
  echo
  echo "Causa típica:"
  echo "  - Tu usuario no está en el grupo 'docker', o"
  echo "  - Docker Desktop no está integrado con WSL, o"
  echo "  - Docker Engine dentro de WSL no está corriendo."
  echo
  echo "Acción:"
  echo "  Ejecuta: ./scripts/07_fix_permissions.sh"
  echo
  exit 1
fi

# 6) Validación de compatibilidad básica de versions (solo informativo)
echo
echo "== Versions (informativo) =="
docker version --format 'Docker {{.Server.Version}}' 2>/dev/null || true
kubectl version --client=true --short 2>/dev/null || true
helm version --short 2>/dev/null || true
k3d version 2>/dev/null || true
node --version 2>/dev/null || true
command -v terraform >/dev/null 2>&1 && terraform version | head -n 1 || true
command -v ansible >/dev/null 2>&1 && ansible --version | head -n 1 || true
command -v k6 >/dev/null 2>&1 && k6 version || true

ok "Validación completada"
