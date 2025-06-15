resource "mongodbatlas_project_ip_access_list" "oci_nat" {
  project_id = mongodbatlas_project.portfolio.id
  ip_address = var.cluster_egress_ip
  comment    = "Cluster Egress IP"
}
