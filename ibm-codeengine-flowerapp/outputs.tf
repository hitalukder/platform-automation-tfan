# Code Engine Project Outputs
output "code_engine_project_id" {
  description = "ID of the Code Engine project"
  value       = ibm_code_engine_project.code_engine_project.project_id
}

output "code_engine_project_crn" {
  description = "CRN of the Code Engine project"
  value       = ibm_code_engine_project.code_engine_project.crn
}

output "code_engine_project_name" {
  description = "Name of the Code Engine project"
  value       = ibm_code_engine_project.code_engine_project.name
}

# Code Engine Application Outputs
output "app_name" {
  description = "Name of the Code Engine application"
  value       = ibm_code_engine_app.serverless_app.name
}

output "app_endpoint" {
  description = "Endpoint URL of the Code Engine application"
  value       = ibm_code_engine_app.serverless_app.endpoint
}

output "app_endpoint_internal" {
  description = "Internal endpoint URL of the Code Engine application"
  value       = ibm_code_engine_app.serverless_app.endpoint_internal
}

output "app_status" {
  description = "Status of the Code Engine application"
  value       = ibm_code_engine_app.serverless_app.status
}

output "app_image_reference" {
  description = "Image reference used by the Code Engine application"
  value       = ibm_code_engine_app.serverless_app.image_reference
}

# ICR Secret Output
output "icr_secret_name" {
  description = "Name of the ICR registry secret"
  value       = ibm_code_engine_secret.icr_secret.name
}

# Custom Domain Outputs (conditional)
output "custom_domain_name" {
  description = "Custom domain name (if configured)"
  value       = var.custom_domain != "" ? ibm_code_engine_domain_mapping.custom_domain[0].name : null
}

output "custom_domain_status" {
  description = "Status of the custom domain mapping (if configured)"
  value       = var.custom_domain != "" ? ibm_code_engine_domain_mapping.custom_domain[0].status : null
}

# Application Configuration Summary
output "application_summary" {
  description = "Summary of the deployed application"
  value = {
    app_name         = ibm_code_engine_app.serverless_app.name
    project_name     = ibm_code_engine_project.code_engine_project.name
    image_reference  = ibm_code_engine_app.serverless_app.image_reference
    endpoint         = ibm_code_engine_app.serverless_app.endpoint
    min_instances    = var.scale_min_instances
    max_instances    = var.scale_max_instances
    cpu_limit        = var.scale_cpu_limit
    memory_limit     = var.scale_memory_limit
  }
}