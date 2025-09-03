# rabbitmq.tf - RabbitMQ Configuration

resource "ibm_database" "rabbitmq" {
  name              = "${local.name_prefix}-rabbitmq"
  service           = "messages-for-rabbitmq"
  plan              = var.rabbitmq_plan
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
  service_endpoints = var.service_endpoints

  # Resource allocation
  group {
    group_id = "member"

    host_flavor {
      id = "multitenant"
    }
    
    cpu {
      allocation_count = 3  # Minimum required is 3
    }

    memory {
      allocation_mb = var.rabbitmq_memory_mb
    }

    disk {
      allocation_mb = var.rabbitmq_disk_mb
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

# Service credentials for RabbitMQ
resource "ibm_resource_key" "rabbitmq_credentials" {
  name                 = "${local.name_prefix}-rabbitmq-key"
  resource_instance_id = ibm_database.rabbitmq.id
  role                 = "Administrator" ## Valid roles are Service Configuration Reader, Viewer, Administrator, Operator, Editor

  parameters = {
    service-endpoints = var.service_endpoints
  }

  depends_on = [ibm_database.rabbitmq]
}