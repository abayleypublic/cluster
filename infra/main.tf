# Adapted from https://cloud.google.com/docs/terraform/resource-management/store-state

resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "state" {
  name     = "${random_id.default.hex}-infra-terraform-state"
  project  = var.project_id
  location = "US-EAST1"

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.module}/backend.tf"

  content = templatefile("${path.module}/backend.tftpl", {
    bucket_name = google_storage_bucket.state.name
  })
}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 7.0.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5.0"
    }
  }
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

provider "cloudflare" {
  api_token = var.cloudflare_api_key
}

provider "google" {
  project = var.gcp_project_id
  region  = "europe-west1"
}

module "cluster" {
  source         = "./modules/oracle"
  compartment_id = var.tenancy_ocid
}

module "dns" {
  source    = "./modules/cloudflare"
  public_ip = module.cluster.public_ip
}

module "gcp" {
  source     = "./modules/gcp"
  project_id = var.gcp_project_id
}
