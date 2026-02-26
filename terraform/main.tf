# ─── NAMESPACE ───────────────────────────────────────────────────────────────

module "namespace" {
  source    = "./modules/namespace"
  namespace = var.namespace
}

# ─── RELEASE ÚNICO — todo el sistema via Helm ────────────────────────────────

resource "helm_release" "nebula_audio" {
  name      = "finlab"
  chart     = var.chart_path
  namespace = var.namespace
  atomic    = true
  timeout   = 300

  depends_on = [module.namespace]

  # Registry
  set {
    name  = "registry"
    value = var.registry
  }

  # Backend gateway
  set {
    name  = "backend.tag"
    value = var.backend.image_tag
  }
  set {
    name  = "backend.replicas"
    value = var.backend.min_replicas
  }
  set {
    name  = "backend.resources.requests.cpu"
    value = var.backend.cpu_request
  }
  set {
    name  = "backend.resources.limits.cpu"
    value = var.backend.cpu_limit
  }
  set {
    name  = "backend.resources.requests.memory"
    value = var.backend.mem_request
  }
  set {
    name  = "backend.resources.limits.memory"
    value = var.backend.mem_limit
  }
  set {
    name  = "backend.hpa.minReplicas"
    value = var.backend.min_replicas
  }
  set {
    name  = "backend.hpa.maxReplicas"
    value = var.backend.max_replicas
  }
  set {
    name  = "backend.hpa.cpuUtilization"
    value = var.cpu_threshold
  }

  # Auth Service
  set {
    name  = "authService.tag"
    value = var.auth_service.image_tag
  }
  set {
    name  = "authService.resources.requests.cpu"
    value = var.auth_service.cpu_request
  }
  set {
    name  = "authService.resources.limits.cpu"
    value = var.auth_service.cpu_limit
  }
  set {
    name  = "authService.resources.requests.memory"
    value = var.auth_service.mem_request
  }
  set {
    name  = "authService.resources.limits.memory"
    value = var.auth_service.mem_limit
  }
  set {
    name  = "authService.hpa.minReplicas"
    value = var.auth_service.min_replicas
  }
  set {
    name  = "authService.hpa.maxReplicas"
    value = var.auth_service.max_replicas
  }
  set {
    name  = "authService.hpa.cpuUtilization"
    value = var.cpu_threshold
  }

  # Audio Service
  set {
    name  = "audioService.tag"
    value = var.audio_service.image_tag
  }
  set {
    name  = "audioService.resources.requests.cpu"
    value = var.audio_service.cpu_request
  }
  set {
    name  = "audioService.resources.limits.cpu"
    value = var.audio_service.cpu_limit
  }
  set {
    name  = "audioService.resources.requests.memory"
    value = var.audio_service.mem_request
  }
  set {
    name  = "audioService.resources.limits.memory"
    value = var.audio_service.mem_limit
  }
  set {
    name  = "audioService.hpa.minReplicas"
    value = var.audio_service.min_replicas
  }
  set {
    name  = "audioService.hpa.maxReplicas"
    value = var.audio_service.max_replicas
  }
  set {
    name  = "audioService.hpa.cpuUtilization"
    value = var.cpu_threshold
  }

  # Analytics Service
  set {
    name  = "analyticsService.tag"
    value = var.analytics_service.image_tag
  }
  set {
    name  = "analyticsService.resources.requests.cpu"
    value = var.analytics_service.cpu_request
  }
  set {
    name  = "analyticsService.resources.limits.cpu"
    value = var.analytics_service.cpu_limit
  }
  set {
    name  = "analyticsService.resources.requests.memory"
    value = var.analytics_service.mem_request
  }
  set {
    name  = "analyticsService.resources.limits.memory"
    value = var.analytics_service.mem_limit
  }
  set {
    name  = "analyticsService.hpa.minReplicas"
    value = var.analytics_service.min_replicas
  }
  set {
    name  = "analyticsService.hpa.maxReplicas"
    value = var.analytics_service.max_replicas
  }
  set {
    name  = "analyticsService.hpa.cpuUtilization"
    value = var.cpu_threshold
  }
}

# ─── HPAs GESTIONADOS DIRECTAMENTE POR TERRAFORM ────────────────────────────

module "hpa_backend" {
  source          = "./modules/hpa"
  name            = "backend"
  namespace       = var.namespace
  deployment_name = "backend"
  min_replicas    = var.backend.min_replicas
  max_replicas    = var.backend.max_replicas
  cpu_threshold   = var.cpu_threshold
  depends_on      = [helm_release.nebula_audio]
}

module "hpa_auth" {
  source          = "./modules/hpa"
  name            = "auth-service"
  namespace       = var.namespace
  deployment_name = "auth-service"
  min_replicas    = var.auth_service.min_replicas
  max_replicas    = var.auth_service.max_replicas
  cpu_threshold   = var.cpu_threshold
  depends_on      = [helm_release.nebula_audio]
}

module "hpa_audio" {
  source          = "./modules/hpa"
  name            = "audio-service"
  namespace       = var.namespace
  deployment_name = "audio-service"
  min_replicas    = var.audio_service.min_replicas
  max_replicas    = var.audio_service.max_replicas
  cpu_threshold   = var.cpu_threshold
  depends_on      = [helm_release.nebula_audio]
}

module "hpa_analytics" {
  source          = "./modules/hpa"
  name            = "analytics-service"
  namespace       = var.namespace
  deployment_name = "analytics-service"
  min_replicas    = var.analytics_service.min_replicas
  max_replicas    = var.analytics_service.max_replicas
  cpu_threshold   = var.cpu_threshold
  depends_on      = [helm_release.nebula_audio]
}
