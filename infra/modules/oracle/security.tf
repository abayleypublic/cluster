resource "oci_bastion_bastion" "k3s_bastion" {
  bastion_type                 = "STANDARD"
  name                         = "k3s_session_manager"
  target_subnet_id             = oci_core_subnet.private_subnet.id
  compartment_id               = oci_identity_compartment.cluster.id
  client_cidr_block_allow_list = ["0.0.0.0/0"]
}