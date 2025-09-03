# IBM Cloud Messaging Stack Terraform

This Terraform configuration provisions a Redis database and RabbitMQ messaging server on IBM Cloud with DevOps best practices.

## Architecture Overview

- **Redis**: In-memory data store for caching and session management
- **RabbitMQ**: Message broker for asynchronous communication
- **IBM Cloud Databases**: Fully managed database services
- **Network Security**: Configurable IP allowlists and optional VPC

## File Structure

```sh
├── main.tf                    # Provider and data source configuration
├── variables.tf               # Variable definitions with validation
├── redis.tf                   # Redis database configuration
├── rabbitmq.tf               # RabbitMQ messaging server configuration
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example  # Example variables file
└── README.md                  # This file
```

## Prerequisites

1. **IBM Cloud Account**: Active IBM Cloud account with billing enabled
2. **API Key**: IBM Cloud API key with appropriate permissions
3. **Terraform**: Version >= 1.0 installed locally
4. **Resource Group**: Existing resource group in IBM Cloud

## Quick Start

### 1. Clone and Setup

```bash
# Clone or download the Terraform files
mkdir ibm-messaging-stack
cd ibm-messaging-stack
# Copy all .tf files into this directory
```

### 2. Configure Variables

```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
vi terraform.tfvars
```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review the deployment plan
terraform plan

# Apply the configuration
terraform apply
```

### 4. Access Your Services

```bash
# Get connection information
terraform output redis_connection_info
terraform output rabbitmq_connection_info

# View deployment summary
terraform output messaging_stack_summary
```

## Configuration Options

### Environment Sizing

**Development Environment:**

```hcl
redis_memory_mb    = 256
redis_disk_mb      = 2048
rabbitmq_memory_mb = 256
rabbitmq_disk_mb   = 2048
```

**Production Environment:**

```hcl
redis_memory_mb    = 4096
redis_disk_mb      = 10240
rabbitmq_memory_mb = 4096
rabbitmq_disk_mb   = 10240
redis_plan         = "enterprise"
rabbitmq_plan      = "enterprise"
```

### Security Configuration

**Restrict Network Access:**

```hcl
allowed_ip_ranges = [
  "10.0.0.0/8",        # Private networks
  "203.0.113.0/24"     # Your office IP range
]
```

**Enable VPC (Enhanced Security):**

1. Uncomment the VPC resources in `networking.tf`
2. Add to your `terraform.tfvars`:

```hcl
enable_vpc = true
```

## Service Access

### Redis Connection

The output provides connection strings in the format:

```sh
rediss://username:password@hostname:port/database
```

### RabbitMQ Connection

- **AMQP**: `amqps://username:password@hostname:5671/`
- **Management UI**: `https://hostname:15671/`

### Retrieving Credentials

```bash
# Get full credentials (sensitive)
terraform output -json redis_endpoints | jq -r '.public_endpoint'
terraform output -json rabbitmq_endpoints | jq -r '.management_url'
```

## Maintenance

### Scaling Resources

Update memory/disk variables in `terraform.tfvars` and run:

```bash
terraform apply
```

### Backup Management

Both services include automatic backups. For point-in-time recovery:

```hcl
# Add to redis.tf or rabbitmq.tf
point_in_time_recovery_deployment_id = "backup-deployment-id"
point_in_time_recovery_time         = "2024-01-15T10:30:00Z"
```

### Monitoring

Access service metrics and logs through:

- IBM Cloud Console
- IBM Cloud CLI: `ibmcloud resource service-instances`
- Terraform outputs for connection details

## Cost Management

### Cost Estimation

- **Standard Plan**: ~$30-50/month per service
- **Enterprise Plan**: ~$200-300/month per service
- **Storage**: Additional costs for disk beyond base allocation

### Cost Optimization

- Use `standard` plans for development
- Right-size memory and disk allocations
- Enable auto-scaling for production workloads
- Monitor usage through IBM Cloud billing dashboard

## Troubleshooting

### Common Issues

**Authentication Errors:**

```bash
# Verify API key
ibmcloud iam api-keys

# Check permissions
ibmcloud iam user-policies USERNAME
```

**Resource Creation Failures:**

- Verify resource group exists
- Check region availability for services
- Ensure sufficient quota limits

**Connection Issues:**

- Verify allowlist configuration
- Check service credentials
- Confirm service status in IBM Cloud console

### Useful Commands

```bash
# Check service status
terraform show | grep status

# Refresh state
terraform refresh

# Force recreation (if needed)
terraform taint ibm_database.redis
terraform apply
```

## Security Best Practices

1. **API Key Management**: Store API keys in environment variables or secure vaults
2. **Network Security**: Restrict allowlists to specific IP ranges
3. **Access Control**: Use least-privilege service credentials
4. **Encryption**: All connections use TLS encryption by default
5. **Monitoring**: Enable IBM Cloud Activity Tracker for audit logs

## Production Checklist

- [ ] API keys stored securely (not in terraform.tfvars)
- [ ] Network allowlists restricted to known IP ranges
- [ ] Enterprise service plans configured
- [ ] Backup strategies defined
- [ ] Monitoring and alerting configured
- [ ] Resource tagging implemented
- [ ] Cost alerts configured
- [ ] Documentation updated

## Support

For issues with:

- **Terraform**: Check Terraform documentation
- **IBM Cloud Provider**: Visit IBM Cloud Terraform provider docs
- **IBM Cloud Services**: Contact IBM Cloud support