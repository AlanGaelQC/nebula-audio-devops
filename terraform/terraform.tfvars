# --- SINGLE SOURCE OF TRUTH — Nebula Audio -----------------------------------
# Modifica aquí para cambiar cualquier valor del sistema completo

namespace     = "finlab"
registry      = "finlab-registry:5000"
image_tag     = "0.1.0"
cpu_threshold = 70
chart_path    = "../infra/helm/finlab"

backend = {
  port         = 3000
  image_tag    = "0.2.4"
  min_replicas = 1
  max_replicas = 3
  cpu_request  = "100m"
  cpu_limit    = "500m"
  mem_request  = "128Mi"
  mem_limit    = "256Mi"
}

auth_service = {
  port         = 3001
  image_tag    = "0.1.0"
  min_replicas = 1
  max_replicas = 4
  cpu_request  = "80m"
  cpu_limit    = "300m"
  mem_request  = "96Mi"
  mem_limit    = "192Mi"
}

audio_service = {
  port         = 3002
  image_tag    = "0.1.0"
  min_replicas = 1
  max_replicas = 6
  cpu_request  = "100m"
  cpu_limit    = "400m"
  mem_request  = "128Mi"
  mem_limit    = "256Mi"
}

analytics_service = {
  port         = 3003
  image_tag    = "0.1.0"
  min_replicas = 1
  max_replicas = 3
  cpu_request  = "80m"
  cpu_limit    = "300m"
  mem_request  = "96Mi"
  mem_limit    = "192Mi"
}




