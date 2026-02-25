#!/usr/bin/env bash
# stress_test.sh — Prueba de carga para demostrar HPA en acción
# Nebula Audio — Fase Infraestructura

set -euo pipefail

GATEWAY="http://localhost:3000"
DURATION=${DURATION:-120}  # segundos
CONCURRENCY=${CONCURRENCY:-20}  # peticiones paralelas

echo "================================================"
echo "  Nebula Audio — Stress Test"
echo "  Gateway: $GATEWAY"
echo "  Duración: ${DURATION}s | Concurrencia: ${CONCURRENCY}"
echo "================================================"
echo ""

# Verificar que el gateway responde
curl -sf "$GATEWAY/healthz" > /dev/null || { echo "ERROR: Gateway no responde en $GATEWAY"; exit 1; }
echo "✓ Gateway activo"
echo ""

echo "▶ Iniciando carga en audio-service (stream de tracks)..."
echo "  Monitorea en otra terminal: watch -n2 'kubectl -n finlab get hpa && echo && kubectl -n finlab get pods | grep audio'"
echo ""

END=$((SECONDS + DURATION))
REQUEST_COUNT=0
ERROR_COUNT=0

while [ $SECONDS -lt $END ]; do
  for i in $(seq 1 $CONCURRENCY); do
    (
      # Alterna entre los 4 tracks disponibles
      TRACK_ID=$(( (RANDOM % 4) + 1 ))
      curl -sf "$GATEWAY/api/audio/stream/$TRACK_ID" > /dev/null 2>&1 || true
    ) &
  done
  wait
  REQUEST_COUNT=$((REQUEST_COUNT + CONCURRENCY))
  echo "  Requests enviados: $REQUEST_COUNT | Tiempo restante: $((END - SECONDS))s"
done

echo ""
echo "================================================"
echo "  Stress test completado"
echo "  Total requests: $REQUEST_COUNT"
echo "================================================"
echo ""
echo "Estado final del HPA:"
kubectl -n finlab get hpa
echo ""
echo "Pods activos:"
kubectl -n finlab get pods | grep -E "audio|auth|analytics|backend"
