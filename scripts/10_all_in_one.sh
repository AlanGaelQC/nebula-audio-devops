#!/usr/bin/env bash
set -euo pipefail

fail() { echo "ERROR: $*" >&2; exit 1; }
ok()   { echo "OK: $*"; }
warn() { echo "WARN: $*" >&2; }

CLUSTER="finlab"
NAMESPACE="finlab"
HOST_REG="localhost:5001"
K3D_REG_NAME="finlab-registry"
TAG="${TAG:-0.1.0}"

echo "================================================"
echo "  Nebula Audio — Full Deploy (Terraform-first)"
echo "  Tag: $TAG"
echo "================================================"
echo ""

# 0) Validación previa
if [ -x "./scripts/06_validate_env.sh" ]; then
  bash ./scripts/06_validate_env.sh
else
  warn "06_validate_env.sh no encontrado, continuando..."
fi

docker ps >/dev/null 2>&1 || fail "Docker no accesible. Asegúrate de que Docker esté corriendo."

# 1) Reset y creación del cluster
echo "== Paso 1: Cluster k3d =="
bash ./scripts/01_cluster_k3d.sh
ok "Cluster listo"

# 2) Build y push de imágenes
echo ""
echo "== Paso 2: Build & Push imágenes =="

[ -d "./apps/backend" ]           || fail "No existe ./apps/backend"
[ -d "./apps/frontend" ]          || fail "No existe ./apps/frontend"
[ -d "./apps/auth-service" ]      || fail "No existe ./apps/auth-service"
[ -d "./apps/audio-service" ]     || fail "No existe ./apps/audio-service"
[ -d "./apps/analytics-service" ] || fail "No existe ./apps/analytics-service"

docker build -t "${HOST_REG}/${NAMESPACE}/backend:0.2.4"           ./apps/backend
docker build -t "${HOST_REG}/${NAMESPACE}/frontend:0.2.7"          ./apps/frontend
docker build -t "${HOST_REG}/${NAMESPACE}/auth-service:${TAG}"      ./apps/auth-service
docker build -t "${HOST_REG}/${NAMESPACE}/audio-service:${TAG}"     ./apps/audio-service
docker build -t "${HOST_REG}/${NAMESPACE}/analytics-service:${TAG}" ./apps/analytics-service

docker push "${HOST_REG}/${NAMESPACE}/backend:0.2.4"
docker push "${HOST_REG}/${NAMESPACE}/frontend:0.2.7"
docker push "${HOST_REG}/${NAMESPACE}/auth-service:${TAG}"
docker push "${HOST_REG}/${NAMESPACE}/audio-service:${TAG}"
docker push "${HOST_REG}/${NAMESPACE}/analytics-service:${TAG}"
ok "Imágenes publicadas"

# 3) Verificar DNS interno del registry
echo ""
echo "== Paso 3: DNS check =="
docker exec "k3d-${CLUSTER}-server-0" sh -c "nslookup ${K3D_REG_NAME} >/dev/null" \
  || fail "El nodo no puede resolver '${K3D_REG_NAME}'"
docker exec "k3d-${CLUSTER}-server-0" sh -c "wget -qO- http://${K3D_REG_NAME}:5000/v2/ >/dev/null" \
  || fail "El nodo no puede acceder al registry"
ok "Registry accesible desde el cluster"

# 4) Terraform — orquestador principal
echo ""
echo "== Paso 4: Terraform init + apply =="
cd terraform

terraform init -input=false
terraform apply -auto-approve -input=false

ok "Infraestructura desplegada por Terraform"
cd ..

# 5) Verificación final
echo ""
echo "== Paso 5: Estado del sistema =="
kubectl -n "$NAMESPACE" get pods
echo ""
kubectl -n "$NAMESPACE" get hpa
echo ""
helm -n "$NAMESPACE" list

# 6) Self-healing check
echo ""
echo "== Paso 6: Self-healing check =="
BACKEND_POD="$(kubectl -n "$NAMESPACE" get pod -l app=backend -o jsonpath='{.items[0].metadata.name}')"
kubectl -n "$NAMESPACE" delete pod "$BACKEND_POD" >/dev/null
kubectl -n "$NAMESPACE" rollout status deploy/backend --timeout=60s
ok "Self-healing validado"

echo ""
echo "================================================"
echo "  Sistema completo desplegado"
echo "  Frontend: kubectl -n finlab port-forward svc/frontend 8080:80"
echo "  Backend:  kubectl -n finlab port-forward svc/backend 3000:3000"
echo "================================================"
