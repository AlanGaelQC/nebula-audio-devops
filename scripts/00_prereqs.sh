#!/usr/bin/env bash
set -euo pipefail

# scripts/00_prereqs.sh
# Valida e instala prerequisitos para el laboratorio en Ubuntu 24.04 (WSL).
# Nota Docker: en WSL se recomienda Docker Desktop (Windows) + WSL Integration.
# Este script NO instala Docker Engine dentro de WSL; valida que docker funcione.

is_wsl() {
  grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

log() { echo -e "\n== $* =="; }

ensure_apt_base() {
  log "APT base packages"
  sudo apt-get update -y
  sudo apt-get install -y git curl ca-certificates gnupg lsb-release unzip tar
}

ensure_docker_desktop_wsl() {
  log "Docker (WSL validation)"
  if ! need_cmd docker; then
    echo "ERROR: 'docker' no está instalado en WSL."
    echo "En WSL lo estable es: instalar Docker Desktop en Windows y habilitar WSL Integration para tu distro."
    echo "Luego ejecutar en PowerShell: wsl --shutdown"
    exit 20
  fi

  # Validar que el daemon responde (Docker Desktop)
  if ! docker ps >/dev/null 2>&1; then
    echo "ERROR: 'docker' existe pero no puede conectarse al daemon."
    echo "Asegura Docker Desktop corriendo y WSL Integration habilitada para tu distro."
    echo "Luego: wsl --shutdown (PowerShell) y reintenta."
    exit 21
  fi

  docker --version
}

ensure_k3d() {
  log "k3d"
  if need_cmd k3d; then
    k3d version
    return
  fi
  curl -fsSL https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
  k3d version
}

ensure_kubectl() {
  log "kubectl"
  if need_cmd kubectl; then
    kubectl version --client=true
    return
  fi

  # Instalación portable sin snap (mejor en WSL):
  local ver
  ver="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
  curl -fsSLo kubectl "https://dl.k8s.io/release/${ver}/bin/linux/amd64/kubectl"
  sudo install -m 0755 kubectl /usr/local/bin/kubectl
  rm -f kubectl
  kubectl version --client=true
}

ensure_helm() {
  log "helm"
  if need_cmd helm; then
    helm version
    return
  fi
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  helm version
}

ensure_k6() {
  log "k6"
  if need_cmd k6; then
    k6 version
    return
  fi

  # k6 en Ubuntu 24.04 suele estar disponible via apt
  sudo apt-get update -y
  sudo apt-get install -y k6 || {
    echo "WARN: No se pudo instalar k6 via apt. Instálalo manualmente si tu repositorio APT no lo incluye."
    echo "Continuando sin k6..."
    return 0
  }
  k6 version
}

main() {
  ensure_apt_base

  # Docker: validar (en WSL) que Docker Desktop está integrado.
  if is_wsl; then
    ensure_docker_desktop_wsl
  else
    # En Linux nativo podrías instalar docker engine aquí, pero tu caso es WSL.
    echo "INFO: No parece WSL. Este script está pensado para WSL + Docker Desktop."
  fi

  ensure_k3d
  ensure_kubectl
  ensure_helm
  ensure_k6

  log "OK"
  echo "Prerequisitos listos."
}

main "$@"
