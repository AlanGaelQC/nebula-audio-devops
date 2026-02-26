# --- GLOBALES ----------------------------------------------------------------

variable "namespace" {
  description = "Namespace de Kubernetes donde se despliega todo el sistema"
  type        = string
  default     = "finlab"
}

variable "registry" {
  description = "Registry interno de imágenes Docker"
  type        = string
  default     = "finlab-registry:5000"
}

variable "image_tag" {
  description = "Tag de imagen por defecto para todos los microservicios"
  type        = string
  default     = "0.1.0"
}

variable "cpu_threshold" {
  description = "Porcentaje de CPU para activar el HPA en todos los servicios"
  type        = number
  default     = 70
}

variable "chart_path" {
  description = "Ruta al chart de Helm del proyecto"
  type        = string
  default     = "../infra/helm/finlab"
}

# --- BACKEND GATEWAY ---------------------------------------------------------

variable "backend" {
  description = "Configuración del API Gateway"
  type = object({
    port         = number
    image_tag    = string
    min_replicas = number
    max_replicas = number
    cpu_request  = string
    cpu_limit    = string
    mem_request  = string
    mem_limit    = string
  })
  default = {
    port         = 3000
    image_tag    = "0.2.4"
    min_replicas = 1
    max_replicas = 3
    cpu_request  = "100m"
    cpu_limit    = "500m"
    mem_request  = "128Mi"
    mem_limit    = "256Mi"
  }
}

# --- AUTH SERVICE -------------------------------------------------------------

variable "auth_service" {
  description = "Configuración del Auth Service"
  type = object({
    port         = number
    image_tag    = string
    min_replicas = number
    max_replicas = number
    cpu_request  = string
    cpu_limit    = string
    mem_request  = string
    mem_limit    = string
  })
  default = {
    port         = 3001
    image_tag    = "0.1.0"
    min_replicas = 1
    max_replicas = 4
    cpu_request  = "80m"
    cpu_limit    = "300m"
    mem_request  = "96Mi"
    mem_limit    = "192Mi"
  }
}

# --- AUDIO SERVICE ------------------------------------------------------------

variable "audio_service" {
  description = "Configuración del Audio Service"
  type = object({
    port         = number
    image_tag    = string
    min_replicas = number
    max_replicas = number
    cpu_request  = string
    cpu_limit    = string
    mem_request  = string
    mem_limit    = string
  })
  default = {
    port         = 3002
    image_tag    = "0.1.0"
    min_replicas = 1
    max_replicas = 6
    cpu_request  = "100m"
    cpu_limit    = "400m"
    mem_request  = "128Mi"
    mem_limit    = "256Mi"
  }
}

# --- ANALYTICS SERVICE -------------------------------------------------------

variable "analytics_service" {
  description = "Configuración del Analytics Service"
  type = object({
    port         = number
    image_tag    = string
    min_replicas = number
    max_replicas = number
    cpu_request  = string
    cpu_limit    = string
    mem_request  = string
    mem_limit    = string
  })
  default = {
    port         = 3003
    image_tag    = "0.1.0"
    min_replicas = 1
    max_replicas = 3
    cpu_request  = "80m"
    cpu_limit    = "300m"
    mem_request  = "96Mi"
    mem_limit    = "192Mi"
  }
}




