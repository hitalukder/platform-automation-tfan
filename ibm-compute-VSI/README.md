# IBM Cloud Virtual Server Instance Terraform

This Terraform configuration creates a virtual server instance in IBM Cloud with the following specifications:

- **Location**: Dallas (us-south) region, zone us-south-2
- **Image**: IBM CentOS Stream 9 AMD64
- **Profile**: bx2-16x64 (16 vCPUs, 64 GB RAM)
- **VPC**: Uses existing
- **Security**: Security group with SSH, HTTP, and HTTPS access
- **Networking**: Optional floating IP for external access

## File Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output values
├── terraform.tfvars.example  # Example variables file
└── README.md                 # This file
```

## Prerequisites

1. **IBM Cloud Account**: Active IBM Cloud account with appropriate permissions
2. **Terraform**: Terraform >= 1.0 installed
3. **Existing Resources**:
   - Resource group in IBM Cloud
   - SSH key uploaded to IBM Cloud
   - VPC named
   - subnets

## Setup

1. **Clone or create the files** in a new directory

2. **Copy the example variables file**:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit `terraform.tfvars`** with your actual values:

   ```hcl
   ibmcloud_api_key = "your-ibm-cloud-api-key"
   resource_group_name = "your-resource-group"
   ssh_key_names = ["your-ssh-key-name"]
   instance_name = "my-server"
   ```

## Usage

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Review the plan**:

   ```bash
   terraform plan
   ```

3. **Apply the configuration**:

   ```bash
   terraform apply
   ```

4. **Connect to your instance**:

   ```bash
   # Use the SSH command from the output
   ssh root@<floating-ip>
   ```

## Configuration Options

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `ibmcloud_api_key` | IBM Cloud API Key | - | Yes |
| `resource_group_name` | Existing resource group name | - | Yes |
| `ssh_key_name` | Existing SSH key name | - | Yes |
| `instance_name` | VSI instance name | `terraform-vsi-dallas` | No |
| `volume_profile` | Volume performance profile | `general-purpose` | No |
| `create_floating_ip` | Create floating IP | `true` | No |
| `tags` | Resource tags | `["terraform", ...]` | No |

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

## Support

For IBM Cloud Terraform provider documentation: https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs