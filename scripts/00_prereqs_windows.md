# Prerrequisitos (Windows 11 + WSL2)

Objetivo: estandarizar entorno para Actividad 4 y Proyecto Final.

1) Windows: habilitar WSL2 y virtualización.
2) Instalar Ubuntu en WSL2 (recomendado).
3) Instalar un runtime de contenedores accesible desde WSL:
   - Opción recomendada: Docker Desktop (con integración WSL) o Rancher Desktop.
4) En Ubuntu (WSL):
   - git
   - node (LTS)
   - kubectl
   - helm
   - k3d
   - docker CLI (si aplica)
   - k6 (para pruebas de carga)

Validación mínima:
- docker version
- k3d version
- kubectl version --client
- helm version
