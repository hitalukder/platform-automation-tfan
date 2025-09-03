# redis.tf - Redis Database Configuration

resource "ibm_database" "redis" {
  name              = "${local.name_prefix}-redis"
  service           = "databases-for-redis"
  plan              = var.redis_plan
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
  service_endpoints = var.service_endpoints

  # Resource allocation based on hosting model
  group {
    group_id = "member"
    
    # Shared compute resources
    dynamic "cpu" {
      for_each = var.redis_hosting_model == "shared" ? [1] : []
      content {
        allocation_count = 3  # Minimum required is 3
      }
    }

    dynamic "memory" {
      for_each = var.redis_hosting_model == "shared" ? [1] : []
      content {
        allocation_mb = var.redis_memory_mb
      }
    }

    # Host flavor for isolated compute
    dynamic "host_flavor" {
      for_each = var.redis_hosting_model == "isolated" ? [1] : []
      content {
        id = var.redis_host_flavor
      }
    }

    # Disk allocation (used for both shared and isolated)
    disk {
      allocation_mb = var.redis_disk_mb
    }

  }

  # Network allowlist
  dynamic "allowlist" {
    for_each = var.allowed_ip_ranges
    content {
      address     = allowlist.value
      description = "Allowed IP range: ${allowlist.value}"
    }
  }

  tags = [
    for k, v in local.common_tags : "${k}:${v}"
  ]

  lifecycle {
    prevent_destroy = false
  }
}

# Service credentials for Redis
resource "ibm_resource_key" "redis_credentials" {
  name                 = "${local.name_prefix}-redis-key"
  resource_instance_id = ibm_database.redis.id
  role                 = "Administrator" # Valid roles are Service Configuration Reader, Viewer, Administrator, Operator, Editor

  parameters = {
    service-endpoints = var.service_endpoints
  }

  depends_on = [ibm_database.redis]
}