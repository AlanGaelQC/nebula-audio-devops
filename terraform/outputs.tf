output "namespace" {
  description = "Namespace donde está desplegado el sistema"
  value       = module.namespace.name
}

output "backend_release" {
  description = "Estado del release del backend gateway"
  value       = helm_release.nebula_audio.status
}

output "auth_service_release" {
  description = "Estado del release del auth service"
  value       = helm_release.nebula_audio.status
}

output "audio_service_release" {
  description = "Estado del release del audio service"
  value       = helm_release.nebula_audio.status
}

output "analytics_service_release" {
  description = "Estado del release del analytics service"
  value       = helm_release.nebula_audio.status
}

output "hpa_backend" {
  description = "Nombre del HPA del backend"
  value       = module.hpa_backend.hpa_name
}

output "hpa_auth" {
  description = "Nombre del HPA del auth service"
  value       = module.hpa_auth.hpa_name
}

output "hpa_audio" {
  description = "Nombre del HPA del audio service"
  value       = module.hpa_audio.hpa_name
}

output "hpa_analytics" {
  description = "Nombre del HPA del analytics service"
  value       = module.hpa_analytics.hpa_name
}
