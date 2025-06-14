resource "mongodbatlas_project" "portfolio" {
  name   = "portfolio"
  org_id = var.org_id
}

resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id   = mongodbatlas_project.portfolio.id
  name         = "Portfolio"
  cluster_type = "REPLICASET"
  replication_specs {
    region_configs {
      electable_specs {
        instance_size = "M0"
      }
      provider_name         = "TENANT"
      backing_provider_name = "GCP"
      priority              = 7
      region_name           = "WESTERN_EUROPE"
    }
  }
}

resource "mongodbatlas_project_ip_access_list" "oci_nat" {
  project_id = mongodbatlas_project.portfolio.id
  ip_address = var.cluster_egress_ip
  comment    = "Cluster Egress IP"
}
