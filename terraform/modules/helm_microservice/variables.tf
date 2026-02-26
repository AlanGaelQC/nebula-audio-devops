variable "name" {
  description = "Nombre del microservicio"
  type        = string
}

variable "namespace" {
  description = "Namespace de Kubernetes donde se despliega"
  type        = string
}

variable "chart_path" {
  description = "Ruta al chart de Helm"
  type        = string
}

variable "registry" {
  description = "Registry de imágenes Docker"
  type        = string
}

variable "image_tag" {
  description = "Tag de la imagen Docker"
  type        = string
}

variable "port" {
  description = "Puerto del microservicio"
  type        = number
}

variable "min_replicas" {
  description = "Réplicas mínimas para el HPA"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Réplicas máximas para el HPA"
  type        = number
}

variable "cpu_threshold" {
  description = "Porcentaje de CPU para activar el HPA"
  type        = number
  default     = 70
}

variable "cpu_request" {
  description = "CPU request del contenedor"
  type        = string
  default     = "100m"
}

variable "cpu_limit" {
  description = "CPU limit del contenedor"
  type        = string
}

variable "mem_request" {
  description = "Memoria request del contenedor"
  type        = string
  default     = "128Mi"
}

variable "mem_limit" {
  description = "Memoria limit del contenedor"
  type        = string
}

variable "extra_env" {
  description = "Variables de entorno adicionales para el servicio"
  type        = map(string)
  default     = {}
}


