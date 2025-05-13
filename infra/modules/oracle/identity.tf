resource "oci_identity_compartment" "cluster" {
  compartment_id = var.compartment_id
  description    = "Kubernetes Cluster"
  name           = "cluster"
  enable_delete  = true
}