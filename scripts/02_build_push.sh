#!/usr/bin/env bash
set -euo pipefail

REG=localhost:5001
TAG=0.1.0

echo "== Build backend =="
docker build -t ${REG}/finlab/backend:${TAG} ./apps/backend

echo "== Build frontend =="
docker build -t ${REG}/finlab/frontend:${TAG} ./apps/frontend

echo "== Push to local registry =="
docker push ${REG}/finlab/backend:${TAG}
docker push ${REG}/finlab/frontend:${TAG}

echo "OK: imágenes publicadas en ${REG}"
