output "public_ip" {
  description = "Public IP of the Oracle instance"
  value       = oci_load_balancer_load_balancer.k3s_lb.ip_address_details[0].ip_address
}

output "vault_id" {
  description = "ID of the secerts vault"
  value       = oci_kms_vault.secret_vault.id
}

output "cluster_compartment_id" {
  description = "Compartment ID of the cluster"
  value       = oci_identity_compartment.cluster.id
}

output "bastion_id" {
  description = "ID of the bastion for SSH access"
  value       = oci_bastion_bastion.k3s_bastion.id
}

output "server_details" {
  description = "Details for the server instances"
  value       = oci_core_instance.server
}

output "egress_ip" {
  description = "Egress IP of the Oracle instance"
  value       = oci_core_public_ip.nat_static.ip_address
}
