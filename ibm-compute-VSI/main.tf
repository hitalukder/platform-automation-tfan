terraform {
  required_version = ">= 1.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.65.0"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

# Use existing VPC by name
data "ibm_is_vpc" "existing_vpc" {
  name = var.vpc_name
}

# Use existing subnet by name within the existing VPC
data "ibm_is_subnet" "existing_subnet" {
  name = var.subnet_name
  vpc  = data.ibm_is_vpc.existing_vpc.id
}

# Use existing SSH keys
data "ibm_is_ssh_key" "ssh_keys" {
  count = length(var.ssh_key_names)
  name  = var.ssh_key_names[count.index]
}

# Use existing Resource Group
data "ibm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

data "ibm_is_security_group" "existing_sg" {
  name = var.existing_security_group_name
}

# Allow inbound SSH
resource "ibm_is_security_group_rule" "ssh" {
  group     = data.ibm_is_security_group.existing_sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

# Create VSI
resource "ibm_is_instance" "vsi" {
  name           = var.instance_name
  image          = var.os_image_id
  profile        = var.instance_profile
  zone           = var.availability_zone
  vpc            = data.ibm_is_vpc.existing_vpc.id
  resource_group = data.ibm_resource_group.existing_rg.id

  primary_network_interface {
    subnet          = data.ibm_is_subnet.existing_subnet.id
    security_groups = [data.ibm_is_security_group.existing_sg.id]
  }

  keys = data.ibm_is_ssh_key.ssh_keys[*].id
  tags = var.tags
}

# Optional: Assign Floating IP
resource "ibm_is_floating_ip" "vsi_floating_ip" {
  count          = var.create_floating_ip ? 1 : 0
  name           = "${var.instance_name}-fip"
  target         = ibm_is_instance.vsi.primary_network_interface[0].id
  resource_group = data.ibm_resource_group.existing_rg.id
  tags           = var.tags
}
