#!/usr/bin/env bash
set -euo pipefail

# scripts/08_setup_playwright_wsl_ideal.sh
# Setup "ideal" para Playwright en WSL/Ubuntu:
# - Instala Node.js 20 (repo NodeSource)
# - Instala dependencias del proyecto E2E
# - Instala browsers + deps de Playwright
#
# Uso:
#   ./scripts/08_setup_playwright_wsl_ideal.sh
#   # luego:
#   kubectl -n finlab port-forward svc/frontend 8080:80
#   cd tests/e2e && E2E_BASE_URL=http://localhost:8080 npx playwright test

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
E2E_DIR="${ROOT_DIR}/tests/e2e"
NODE_MAJOR="20"

log() { echo -e "\n== $* =="; }
fail() { echo "ERROR: $*" >&2; exit 1; }

log "prechecks"
[ -d "$E2E_DIR" ] || fail "No existe $E2E_DIR. Ejecuta desde la raíz del repo."
if ! grep -qiE "(microsoft|wsl)" /proc/version; then
  echo "WARN: No detecto WSL. Si estás en Linux nativo está OK; si estás en Windows, este script no aplica."
fi

log "base packages"
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg git

log "install Node.js ${NODE_MAJOR} (NodeSource)"
# NodeSource repo (recomendado para tener Node 20 estable en Ubuntu)
curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | sudo -E bash -
sudo apt-get install -y nodejs

log "verify node/npm"
node -v
npm -v
node -p "process.platform" | grep -qx "linux" || fail "Node no es linux (algo está mal con el entorno)."

log "install e2e dependencies"
cd "$E2E_DIR"

# Para un setup ideal NO borramos lockfile; usamos npm ci si existe.
rm -rf node_modules
if [ -f package-lock.json ]; then
  npm ci
else
  npm install
fi

log "install Playwright browsers + linux deps"
npx playwright install --with-deps

log "done"
echo "Siguiente:"
echo "  1) En otra terminal: kubectl -n finlab port-forward svc/frontend 8080:80"
echo "  2) Luego: cd tests/e2e && E2E_BASE_URL=http://localhost:8080 npx playwright test"
