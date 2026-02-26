resource "kubernetes_horizontal_pod_autoscaler_v2" "this" {
  metadata {
    name      = "hpa-${var.name}"
    namespace = var.namespace
    labels = {
      "managed-by" = "terraform"
      "project"    = "nebula-audio"
    }
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.deployment_name
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.cpu_threshold
        }
      }
    }
  }
}

output "hpa_name" {
  value = kubernetes_horizontal_pod_autoscaler_v2.this.metadata[0].name
}


