variable "ibmcloud_api_key" {
  description = "IBM Cloud API Key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "IBM Cloud region (e.g., us-south)"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone to deploy the instance in (e.g., us-south-2)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing IBM Cloud resource group"
  type        = string
}

variable "vpc_name" {
  description = "Name of the existing VPC"
  type        = string
}

variable "subnet_name" {
  description = "Name of the existing subnet"
  type        = string
}

variable "ssh_key_names" {
  description = "List of SSH key names to attach to the instance"
  type        = list(string)
}

variable "instance_name" {
  description = "Name of the Virtual Server Instance"
  type        = string
}

variable "existing_security_group_name" {
  description = "Name of the existing security group to attach to the instance"
  type        = string
}

variable "os_image_id" {
  description = "Image ID to use for the VSI (e.g., Ubuntu, CentOS)"
  type        = string
}

variable "instance_profile" {
  description = "Instance profile (e.g., bx2-2x8)"
  type        = string
}

variable "create_floating_ip" {
  description = "Set to true to create and attach a floating IP"
  type        = bool
  default     = true
}

variable "tags" {
  description = "List of tags to apply to the resources"
  type        = list(string)
  default     = []
}
