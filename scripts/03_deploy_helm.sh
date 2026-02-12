#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=finlab
helm upgrade --install finlab ./infra/helm/finlab -n ${NAMESPACE} --create-namespace

echo "== Estado =="
kubectl -n ${NAMESPACE} get deploy,svc,pods
