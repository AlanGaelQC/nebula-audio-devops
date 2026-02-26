locals {
  service_key = {
    "auth-service"      = "authService"
    "audio-service"     = "audioService"
    "analytics-service" = "analyticsService"
  }
  key = lookup(local.service_key, var.name, var.name)
}

resource "helm_release" "microservice" {
  name       = var.name
  chart      = var.chart_path
  namespace  = var.namespace
  atomic     = true
  timeout    = 180

  set {
    name  = "registry"
    value = var.registry
  }

  set {
    name  = "${local.key}.image"
    value = "finlab/${var.name}"
  }

  set {
    name  = "${local.key}.tag"
    value = var.image_tag
  }

  set {
    name  = "${local.key}.port"
    value = var.port
  }

  set {
    name  = "${local.key}.resources.requests.cpu"
    value = var.cpu_request
  }

  set {
    name  = "${local.key}.resources.limits.cpu"
    value = var.cpu_limit
  }

  set {
    name  = "${local.key}.resources.requests.memory"
    value = var.mem_request
  }

  set {
    name  = "${local.key}.resources.limits.memory"
    value = var.mem_limit
  }

  set {
    name  = "${local.key}.hpa.minReplicas"
    value = var.min_replicas
  }

  set {
    name  = "${local.key}.hpa.maxReplicas"
    value = var.max_replicas
  }

  set {
    name  = "${local.key}.hpa.cpuUtilization"
    value = var.cpu_threshold
  }

  dynamic "set" {
    for_each = var.extra_env
    content {
      name  = "${local.key}.env.${set.key}"
      value = set.value
    }
  }
}

output "release_name" {
  value = helm_release.microservice.name
}

output "release_status" {
  value = helm_release.microservice.status
}
