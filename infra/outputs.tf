output "vault_id" {
  value = module.cluster.vault_id
}

output "compartment_id" {
  value = module.cluster.cluster_compartment_id
}

output "bastion_id" {
  value = module.cluster.bastion_id
}

output "server_id" {
  value = module.cluster.server_details["server-1"].id
}

output "server_ip" {
  value = module.cluster.server_details["server-1"].private_ip
}

