resource "google_project_service" "gar" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "docker_repository" {
  project       = google_project_service.gar.project
  location      = var.region
  repository_id = "docker-repository"
  description   = "Docker image repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}
