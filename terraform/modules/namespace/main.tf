variable "namespace" {
  description = "Nombre del namespace a crear"
  type        = string
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
    labels = {
      "managed-by" = "terraform"
      "project"    = "nebula-audio"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].annotations]
  }
}

output "name" {
  value = kubernetes_namespace.this.metadata[0].name
}


