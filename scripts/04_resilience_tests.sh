#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=finlab

echo "== Ver replicas =="
kubectl -n ${NAMESPACE} get deploy backend frontend

echo "== Eliminar 1 pod backend (self-healing) =="
POD=$(kubectl -n ${NAMESPACE} get pod -l app=backend -o jsonpath='{.items[0].metadata.name}')
echo "Deleting $POD"
kubectl -n ${NAMESPACE} delete pod "$POD"

echo "== Esperar recuperación =="
kubectl -n ${NAMESPACE} rollout status deploy/backend

echo "== Escalar backend a 4 replicas =="
kubectl -n ${NAMESPACE} scale deploy/backend --replicas=4
kubectl -n ${NAMESPACE} rollout status deploy/backend
kubectl -n ${NAMESPACE} get pod -l app=backend

echo "OK: pruebas básicas de resiliencia"
