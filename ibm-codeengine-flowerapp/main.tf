# Configure the IBM Cloud Provider for Code Engine
terraform {
  required_version = ">= 1.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.65"
    }
  }
}

# Configure the IBM Provider
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

# Data source to get resource group
data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

# Create Code Engine Project
resource "ibm_code_engine_project" "code_engine_project" {
  name              = var.project_name
  resource_group_id = data.ibm_resource_group.resource_group.id
}

resource "ibm_resource_tag" "code_engine_tags" {
  resource_id = ibm_code_engine_project.code_engine_project.crn
  tags        = var.tags
}

# Create registry access secret for Code Engine to pull from ICR
resource "ibm_code_engine_secret" "icr_secret" {
  project_id = ibm_code_engine_project.code_engine_project.project_id
  name       = "${var.app_name}-icr-secret"
  format     = "registry"
  
  data = {
    "server"   = "${var.icr_region}.icr.io"
    "username" = "iamapikey"
    "password" = var.ibmcloud_api_key
  }
}

# Create Code Engine Application (Serverless Container)
resource "ibm_code_engine_app" "serverless_app" {
  project_id      = ibm_code_engine_project.code_engine_project.project_id
  name            = var.app_name
  image_reference = "${var.icr_region}.icr.io/${var.container_registry_namespace}/${var.image_name}:${var.image_tag}"
  image_secret    = ibm_code_engine_secret.icr_secret.name
  image_port      = var.app_port

  # Scaling configuration
  scale_min_instances      = var.scale_min_instances
  scale_max_instances      = var.scale_max_instances
  scale_cpu_limit         = var.scale_cpu_limit
  scale_memory_limit      = var.scale_memory_limit
  scale_initial_instances = var.scale_initial_instances

  # Runtime configuration
  run_service_account = "default"
  #run_commands        = var.run_commands
  #run_arguments       = var.run_arguments
  
  # Environment variables
  dynamic "run_env_variables" {
    for_each = var.environment_variables
    content {
      type  = run_env_variables.value.type
      name  = run_env_variables.value.name
      value = run_env_variables.value.value
    }
  }

  # Optional: Volume mounts
  dynamic "run_volume_mounts" {
    for_each = var.volume_mounts
    content {
      mount_path = run_volume_mounts.value.mount_path
      name       = run_volume_mounts.value.name
      reference  = run_volume_mounts.value.reference
      type       = run_volume_mounts.value.type
    }
  }

  # Optional: Set the port if the application listens on a specific port
}



# Optional: Create a custom domain mapping
resource "ibm_code_engine_domain_mapping" "custom_domain" {
  count      = var.custom_domain != "" ? 1 : 0
  project_id = ibm_code_engine_project.code_engine_project.project_id
  name       = var.custom_domain
  component {
    name          = ibm_code_engine_app.serverless_app.name
    resource_type = "app_v2"
  }
  tls_secret = var.tls_secret_name
}