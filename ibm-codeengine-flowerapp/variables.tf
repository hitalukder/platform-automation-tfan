# IBM Cloud Configuration
variable "ibmcloud_api_key" {
  description = "IBM Cloud API key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
  default     = "us-south"
}

variable "icr_region" {
  description = "IBM Cloud container registry region"
  type        = string
  default     = "us"
}

variable "resource_group_name" {
  description = "Name of the IBM Cloud resource group"
  type        = string
  default     = "default"
}

variable "tags" {
  description = "List of tags to apply to resources"
  type        = list(string)
  default     = []
}

# Container Registry Configuration (for referencing existing namespace)
variable "container_registry_namespace" {
  description = "IBM Container Registry namespace (must exist)"
  type        = string
}

# Image Configuration
variable "image_name" {
  description = "Name of the Docker image in ICR"
  type        = string
  default     = "my-app"
}

variable "image_tag" {
  description = "Tag of the Docker image to deploy"
  type        = string
  default     = "latest"
}

# Code Engine Project Configuration
variable "project_name" {
  description = "Name of the Code Engine project"
  type        = string
  validation {
    condition     = can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.project_name))
    error_message = "Project name must start with a lowercase letter, end with an alphanumeric character, and contain only lowercase letters, numbers, and hyphens."
  }
}

# Code Engine Application Configuration
variable "app_name" {
  description = "Name of the Code Engine application"
  type        = string
  validation {
    condition     = can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.app_name))
    error_message = "Application name must start with a lowercase letter, end with an alphanumeric character, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "app_port" {
  description = "Port on which the application listens"
  type        = number
  default     = 8080
}

# Scaling Configuration
variable "scale_min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "scale_max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "scale_initial_instances" {
  description = "Initial number of instances"
  type        = number
  default     = 1
}

variable "scale_cpu_limit" {
  description = "CPU limit per instance"
  type        = string
  default     = "1"
}

variable "scale_memory_limit" {
  description = "Memory limit per instance"
  type        = string
  default     = "4Gi"
}

# Runtime Configuration
# variable "run_commands" {
#  description = "Commands to run in the container"
#  type        = list(string)
#  default     = ["celery"]
#}

#variable "run_arguments" {
#  description = "Arguments to pass to the run commands"
#  type        = list(string)
#  default     = ["--broker=$(CELERY_BROKER_URL)", "flower", "--port=5555", "--basic_auth=$(FLOWER_BASIC_AUTH)"]
# }

# Environment Variables
variable "environment_variables" {
  description = "Environment variables for the application"
  type = list(object({
    type  = string
    name  = string
    value = string
  }))
  default = []
}

# Volume Mounts
variable "volume_mounts" {
  description = "Volume mounts for the application"
  type = list(object({
    mount_path = string
    name       = string
    reference  = string
    type       = string
  }))
  default = []
}

# Health Probes
variable "liveness_probe" {
  description = "Liveness probe configuration"
  type = object({
    failure_threshold     = number
    initial_delay_seconds = number
    interval_seconds      = number
    path                  = string
    port                  = number
    timeout_seconds       = number
    type                  = string
  })
  default = null
}

variable "readiness_probe" {
  description = "Readiness probe configuration"
  type = object({
    failure_threshold     = number
    initial_delay_seconds = number
    interval_seconds      = number
    path                  = string
    port                  = number
    timeout_seconds       = number
    type                  = string
  })
  default = null
}

# Custom Domain Configuration
variable "custom_domain" {
  description = "Custom domain for the application"
  type        = string
  default     = ""
}

variable "tls_secret_name" {
  description = "TLS secret name for custom domain"
  type        = string
  default     = ""
}