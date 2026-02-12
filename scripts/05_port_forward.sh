#!/usr/bin/env bash
set -euo pipefail
NAMESPACE=finlab
echo "Abriendo frontend en http://localhost:8080"
kubectl -n ${NAMESPACE} port-forward svc/frontend 8080:80
