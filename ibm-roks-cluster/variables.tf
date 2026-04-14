variable "ibmcloud_api_key" {
  description = "IBM Cloud API key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "IBM Cloud region for the OpenShift cluster"
  type        = string
  default     = "us-south"
}

variable "resource_group_name" {
  description = "Name of the existing IBM Cloud resource group"
  type        = string
}

variable "cluster_name" {
  description = "Name of the OpenShift cluster"
  type        = string
  default     = "my-openshift-cluster"
}

variable "ocp_version" {
  description = "OpenShift version (e.g. 4.16_openshift). Run 'ibmcloud ks versions' to list available versions."
  type        = string
  default     = "4.16_openshift"
}

variable "worker_pool_flavor" {
  description = "Machine flavor for worker nodes"
  type        = string
  default     = "bx2.4x16"
}

variable "worker_count" {
  description = "Number of worker nodes per zone"
  type        = number
  default     = 2

  validation {
    condition     = var.worker_count >= 1
    error_message = "Worker count must be at least 1 for each zone for high availability."
  }
}

variable "worker_zones" {
  description = "List of zones for worker nodes"
  type        = list(string)
  default     = ["us-south-1", "us-south-2", "us-south-3"]
}

variable "ocp_entitlement" {
  description = "OpenShift entitlement. Set to 'cloud_pak' only if you have an active Cloud Pak license. Leave empty otherwise."
  type        = string
  default     = ""
}

variable "disable_public_service_endpoint" {
  description = "Set to true to disable the public Kubernetes API endpoint (private-only access)"
  type        = bool
  default     = false
}

variable "allowed_inbound_cidr" {
  description = "CIDR block allowed for inbound HTTP/HTTPS traffic. Use '0.0.0.0/0' for public access or restrict to your network."
  type        = string
  default     = "0.0.0.0/0"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "List of tags to apply to all resources"
  type        = list(string)
  default     = []
}

variable "enable_monitoring" {
  description = "Enable monitoring and logging for the cluster"
  type        = bool
  default     = false
}

variable "logdna_instance_id" {
  description = "LogDNA instance ID for cluster logging (required if enable_monitoring is true)"
  type        = string
  default     = ""
}

variable "sysdig_instance_id" {
  description = "Sysdig instance ID for cluster monitoring (required if enable_monitoring is true)"
  type        = string
  default     = ""
}
