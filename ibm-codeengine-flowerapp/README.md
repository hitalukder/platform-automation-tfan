# Flower Celery Monitoring on IBM Cloud Code Engine

This deployment sets up **Flower**, a web-based tool for monitoring and administering Celery clusters, on IBM Cloud Code Engine as a serverless container application.

***The prerequisite of this terraform script that you have pushed your image in IBM cloud container registry.***

## What is Flower?

Flower is a real-time monitor and web admin for Celery distributed task queue. It provides:

- **Real-time monitoring** of Celery workers and tasks
- **Task management** - inspect, retry, revoke tasks  
- **Worker statistics** - active/processed tasks, load averages
- **Broker monitoring** - queue lengths, message rates
- **Web-based interface** - accessible from any browser

## Quick Deploy

### 1. Configure Flower Settings

Create or update `flower.tfvars` with your specific configuration:

```bash
cp flower.tfvars.example flower.tfvars
# Edit flower.tfvars with your settings
```

**Key configurations to update:**

```hcl
# Your IBM Cloud credentials
ibmcloud_api_key      = "your-ibm-cloud-api-key-here"

# Code Engine Project
project_name = "unspsc-ps-monitoring-project"

# Flower Application Configuration
app_name        = "flower-monitoring-project"

container_registry_namespace = "ibm-container-registry-namespace"
image_name    = "your-custom-image-name"
image_tag     = "v1"
app_port      = 5555  # Flower default port

environment_variables = [
  {
    type  = "literal"
    name  = "CELERY_BROKER_URL"
    value = "amqp://guest:guest@your-rabbitmq-host:5672//"  # Update with your RabbitMQ host
  },
  {
    type  = "literal"
    name  = "FLOWER_PORT"
    value = "5555"
  },
  {
    type  = "literal"
    name  = "FLOWER_UNAUTHENTICATED_API"
    value = "true"
  },
  {
    type  = "literal"
    name  = "CELERY_RESULT_BACKEND"
    value = "rpc://"
  },
  {
    type  = "literal"
    name  = "FLOWER_BASIC_AUTH"
    value = "admin:admin"  # Change this in production
  },
  {
    type  = "literal"
    name  = "CELERY_RESULT_BACKEND"
    value = "rpc://"
  }
]

```

### Manual Terraform Commands

```bash
# Initialize with Flower config
terraform init -backend-config=backend.tfbackend

# Plan with Flower variables
terraform plan -var-file=flower.tfvars

# Apply deployment
terraform apply -var-file=flower.tfvars

# Destroy when done
terraform destroy -var-file=flower.tfvars
```

```bash
terraform state rm ibm_code_engine_project.code_engine_project
```

## Accessing Flower

After deployment:

1. **Get the URL**: Check terraform outputs for `app_url`
2. **Login**: Use credentials from `FLOWER_BASIC_AUTH`
3. **Monitor**: View workers, tasks, and broker statistics

## Support and Documentation

- [Flower Documentation](https://flower.readthedocs.io/)
- [Celery Documentation](https://docs.celeryproject.org/)
- [IBM Cloud Code Engine Docs](https://cloud.ibm.com/docs/codeengine)
- [Terraform IBM Provider](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs)