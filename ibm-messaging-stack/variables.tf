# variables.tf - Variable Definitions

variable "ibm_api_key" {
  description = "IBM Cloud API Key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
  default     = "us-south"
  validation {
    condition = contains([
      "us-south", "us-east", "eu-gb", "eu-de", 
      "jp-tok", "au-syd", "ca-tor", "br-sao"
    ], var.region)
    error_message = "Region must be a valid IBM Cloud region."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "cs-dev-workload"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "unspsc-messaging"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "redis_plan" {
  description = "Redis service plan"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "enterprise"], var.redis_plan)
    error_message = "Redis plan must be either 'standard' or 'enterprise'."
  }
}

variable "rabbitmq_plan" {
  description = "RabbitMQ service plan"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "enterprise"], var.rabbitmq_plan)
    error_message = "RabbitMQ plan must be either 'standard' or 'enterprise'."
  }
}

variable "redis_memory_mb" {
  description = "Redis memory allocation in MB"
  type        = number
  default     = 4096
  validation {
    condition     = var.redis_memory_mb >= 256 && var.redis_memory_mb <= 32768
    error_message = "Redis memory must be between 256 MB and 32 GB."
  }
}

variable "redis_disk_mb" {
  description = "Redis disk allocation in MB"
  type        = number
  default     = 6144
}

variable "rabbitmq_memory_mb" {
  description = "RabbitMQ memory allocation in MB"
  type        = number
  default     = 8192
  validation {
    condition     = var.rabbitmq_memory_mb >= 256 && var.rabbitmq_memory_mb <= 32768
    error_message = "RabbitMQ memory must be between 256 MB and 32 GB."
  }
}

variable "rabbitmq_disk_mb" {
  description = "RabbitMQ disk allocation in MB"
  type        = number
  default     = 6144
}

variable "allowed_ip_ranges" {
  description = "List of IP ranges allowed to access the databases"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "service_endpoints" {
  default = "public"
  description = "Service endpoints type: public, private"
}

variable "redis_hosting_model" {
  default = "shared"
  description = "Redis hosting model: shared or isolated"
}

variable "redis_host_flavor" {
  default     = "bx2-2x8"
  description = "Host flavor for isolated Redis instances"
}