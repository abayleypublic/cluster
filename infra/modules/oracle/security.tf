# ==========
# Bastion for SSH access to instances
# ==========

resource "oci_bastion_bastion" "k3s_bastion" {
  bastion_type                 = "STANDARD"
  name                         = "k3s_session_manager"
  target_subnet_id             = oci_core_subnet.private_subnet.id
  compartment_id               = oci_identity_compartment.cluster.id
  client_cidr_block_allow_list = ["0.0.0.0/0"]
}

# ==========
# Vault access from k3s nodes
# ==========

resource "oci_identity_dynamic_group" "k3s_nodes" {
  compartment_id = var.compartment_id
  name           = "k3s_dynamic_group"
  description    = "Group for k3s nodes to access OCI Vault"

  matching_rule = "ALL {instance.compartment.id = '${oci_identity_compartment.cluster.id}'}"
}

resource "oci_identity_policy" "k3s_vault_access" {
  compartment_id = oci_identity_compartment.cluster.id
  name           = "k3s_vault_access"
  description    = "Allow dynamic group to access secret bundles"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.k3s_nodes.name} to read secret-bundles in compartment ${oci_identity_compartment.cluster.name}"
  ]
}