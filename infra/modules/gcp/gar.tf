resource "google_artifact_registry_repository" "docker_repository" {
  project       = var.project_id
  location      = var.region
  repository_id = "docker-repository"
  description   = "Docker image repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }

  cleanup_policy_dry_run = false

  cleanup_policies {
    action = "KEEP"
    id     = "cleanup_old_versions"

    most_recent_versions {
      keep_count            = 2
      package_name_prefixes = []
    }
  }
}
