#!/usr/bin/env bash
set -euo pipefail

# Cluster k3d con registry local para evitar dependencias externas
# Registry: localhost:5001

k3d cluster delete finlab >/dev/null 2>&1 || true

k3d cluster create finlab   --agents 2   --registry-create finlab-registry:0.0.0.0:5001

kubectl create ns finlab >/dev/null 2>&1 || true

echo "OK: cluster finlab listo"
kubectl get nodes
