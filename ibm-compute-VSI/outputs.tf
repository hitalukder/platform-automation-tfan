output "instance_id" {
  description = "ID of the created instance"
  value       = ibm_is_instance.vsi.id
}

output "instance_name" {
  description = "Name of the created instance"
  value       = ibm_is_instance.vsi.name
}

output "instance_status" {
  description = "Status of the created instance"
  value       = ibm_is_instance.vsi.status
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = ibm_is_instance.vsi.primary_network_interface[0].primary_ip[0].address
}

output "public_ip" {
  description = "Public IP address of the instance (if floating IP is created)"
  value       = var.create_floating_ip ? ibm_is_floating_ip.vsi_floating_ip[0].address : "No floating IP created"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value = var.create_floating_ip ? "ssh root@${ibm_is_floating_ip.vsi_floating_ip[0].address}" : "ssh root@${ibm_is_instance.vsi.primary_network_interface[0].primary_ip[0].address}"
}

output "availability_zone" {
  description = "Availability zone of the instance"
  value       = ibm_is_instance.vsi.zone
}