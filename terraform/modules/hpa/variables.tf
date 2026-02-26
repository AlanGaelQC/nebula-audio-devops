variable "name" {
  description = "Nombre del HPA (debe coincidir con el deployment target)"
  type        = string
}

variable "namespace" {
  description = "Namespace de Kubernetes"
  type        = string
}

variable "deployment_name" {
  description = "Nombre del Deployment que escala este HPA"
  type        = string
}

variable "min_replicas" {
  description = "Réplicas mínimas"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Réplicas máximas"
  type        = number
}

variable "cpu_threshold" {
  description = "Porcentaje de CPU para activar el escalado"
  type        = number
  default     = 70
}


