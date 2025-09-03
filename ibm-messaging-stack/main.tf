# main.tf - Main Terraform Configuration

terraform {
  required_version = ">= 1.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.65.0"
    }
  }
}

# Provider configuration
provider "ibm" {
  ibmcloud_api_key = var.ibm_api_key
  region           = var.region
}

# Data sources
data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

# Local values for consistent naming
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}