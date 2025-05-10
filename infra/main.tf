resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "state" {
  name     = "${random_id.default.hex}-infra-terraform-state"
  project = var.project_id
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