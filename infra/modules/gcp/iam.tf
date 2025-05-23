resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  display_name = "Github Actions Service Account"
}

resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Kubernetes Service Account"
}

# Workload Identity Federation

resource "google_project_service" "crm" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sts" {
  project            = var.project_id
  service            = "sts.googleapis.com"
  disable_on_destroy = false
}
