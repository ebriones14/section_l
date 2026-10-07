output "api_url" {
  description = "Public URL for the Render Rails API."
  value       = render_web_service.api.url
}

output "frontend_url" {
  description = "Stable production URL for the Vercel frontend."
  value       = local.frontend_origin
}

output "deployment_url" {
  description = "URL of the Vercel deployment created by Terraform."
  value       = vercel_deployment.frontend.url
}
