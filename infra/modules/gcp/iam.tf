resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  display_name = "Github Actions Service Account"
}

resource "google_service_account_iam_member" "github_actions_workload_identity_binding" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository_owner/abayleypublic"
}

resource "google_project_iam_member" "github_actions_artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_service_account" "image_pull" {
  account_id   = "image-pull"
  display_name = "Image Pull Service Account"
}

resource "google_service_account_iam_member" "image_pull_workload_identity_binding" {
  service_account_id = google_service_account.image_pull.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.kubernetes.workload_identity_pool_id}/subject/system:serviceaccount:default:image-pull"
}

resource "google_project_iam_member" "image_pull_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.image_pull.email}"
}

# ==========
# Workload Identity Federation
# ==========

resource "google_iam_workload_identity_pool" "kubernetes" {
  workload_identity_pool_id = "kubernetes"
  display_name              = "Kubernetes"
  description               = "Portfolio cluster workload identity pool"
}

resource "google_iam_workload_identity_pool_provider" "cluster" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.kubernetes.workload_identity_pool_id
  workload_identity_pool_provider_id = "cluster"
  display_name                       = "Cluster"
  description                        = "Workload identity provider for Kubernetes cluster"

  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }

  oidc {
    issuer_uri = "https://kube.austinbayley.co.uk"
  }
}

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github"
  display_name              = "Github"
  description               = "Github workload identity pool"
}

resource "google_iam_workload_identity_pool_provider" "actions" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "actions"
  display_name                       = "Actions"
  description                        = "Workload identity provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_condition = "assertion.repository_owner == 'abayleypublic'"
}
