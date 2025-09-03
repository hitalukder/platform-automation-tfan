# outputs.tf - Output Definitions

# Redis Outputs
output "redis_connection_info" {
  description = "Redis connection information"
  value = {
    instance_id = ibm_database.redis.id
    guid        = ibm_database.redis.guid
    status      = ibm_database.redis.status
    version     = ibm_database.redis.version
    crn         = ibm_database.redis.resource_crn
    name        = ibm_database.redis.name
  }
}

output "redis_service_credentials" {
  description = "Redis service credentials (use these for connection details)"
  value = {
    credentials_id = ibm_resource_key.redis_credentials.id
    credentials_crn = ibm_resource_key.redis_credentials.crn
  }
}

# RabbitMQ Outputs
output "rabbitmq_connection_info" {
  description = "RabbitMQ connection information"
  value = {
    instance_id = ibm_database.rabbitmq.id
    guid        = ibm_database.rabbitmq.guid
    status      = ibm_database.rabbitmq.status
    version     = ibm_database.rabbitmq.version
    crn         = ibm_database.rabbitmq.resource_crn
    name        = ibm_database.rabbitmq.name
  }
}

output "rabbitmq_service_credentials" {
  description = "RabbitMQ service credentials (use these for connection details)"
  value = {
    credentials_id = ibm_resource_key.rabbitmq_credentials.id
    credentials_crn = ibm_resource_key.rabbitmq_credentials.crn
  }
}

# Combined outputs for application configuration
output "messaging_stack_summary" {
  description = "Summary of the messaging stack deployment"
  value = {
    redis = {
      name   = ibm_database.redis.name
      status = ibm_database.redis.status
      plan   = var.redis_plan
    }
    rabbitmq = {
      name   = ibm_database.rabbitmq.name
      status = ibm_database.rabbitmq.status
      plan   = var.rabbitmq_plan
    }
    deployment_info = {
      region      = var.region
      environment = var.environment
      project     = var.project_name
    }
  }
}

# Instructions for accessing connection details
output "connection_instructions" {
  description = "Instructions for retrieving connection details"
  value = <<-EOT
    To get connection details, use IBM Cloud CLI:
    
    Redis:
    ibmcloud resource service-key ${ibm_resource_key.redis_credentials.name}
    
    RabbitMQ:
    ibmcloud resource service-key ${ibm_resource_key.rabbitmq_credentials.name}
    
    Or use the IBM Cloud console to view service credentials.
  EOT
}