# FinLab DevOps (Actividad 4 + Proyecto Final)

Este repositorio está diseñado para que el alumno NO construya la app desde cero, sino que practique DevOps (T1–T14):
contenedores, Kubernetes, Helm, CI/CD (GitHub Actions + Jenkins), pruebas (unit/integration/e2e/perf),
y IaC (Terraform + Ansible) en ambiente local.

## Arquitectura
- Frontend: React (Vite) -> build estático -> Nginx
- Backend: Node/Express (API REST) + health checks
- DB: Postgres (modo laboratorio)
- K8s: Deployments/Services + probes + HPA (opcional)
- Helm: chart `finlab`
- CI/CD:
  - GitHub Actions: lint + unit tests + build
  - Jenkins: integration/e2e/perf + build/push imágenes + deploy Helm a cluster local
- Testing:
  - Unit: Jest (backend)
  - E2E: Playwright (UI)
  - Perf: k6 (API)
- IaC:
  - Terraform: ejemplo de infraestructura (validación local)
  - Ansible: ejemplo de automatización (playbooks)

## Rutas
- `apps/backend`         API Node/Express
- `apps/frontend`        React + Vite
- `tests/e2e`            Playwright
- `tests/perf`           k6
- `infra/helm/finlab`    Helm chart
- `infra/terraform`      Terraform (demo)
- `infra/ansible`        Ansible (demo)
- `scripts`              comandos guiados para clase

## Inicio rápido (clase)
1) Ver `scripts/00_prereqs_windows.md`
2) Crear cluster: `scripts/01_cluster_k3d.sh`
3) Levantar Postgres local (opcional para dev): `docker compose up -d db`
4) Build/push imágenes al registry local: `scripts/02_build_push.sh`
5) Deploy con Helm: `scripts/03_deploy_helm.sh`
6) Validar y probar resiliencia: `scripts/04_resilience_tests.sh`
7) Port-forward: `scripts/05_port_forward.sh`

## Variables
- Registry local (k3d): `localhost:5001`
- Namespace: `finlab`

## Licencia
Material educativo.
