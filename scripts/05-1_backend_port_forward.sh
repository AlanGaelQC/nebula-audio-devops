#!/usr/bin/env bash
set -euo pipefail
NAMESPACE=finlab
echo "Abriendo backend en http://localhost:3000"
kubectl -n ${NAMESPACE} port-forward svc/backend 3000:3000