resource "google_project_service" "services" {
  for_each = toset([
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "apikeys.googleapis.com",
    "geocoding-backend.googleapis.com",
  ])
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
