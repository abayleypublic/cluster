output "public_ip" {
  description = "Public IP of the Oracle instance"
  value       = oci_load_balancer_load_balancer.k3s_lb.ip_address_details[0].ip_address
}

output "vault_id" {
  description = "ID of the secerts vault"
  value       = oci_kms_vault.secret_vault.id
}
