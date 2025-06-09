resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Kubernetes Service Account"
}

resource "google_service_account_iam_member" "kubernetes_workload_identity_binding" {
  service_account_id = google_service_account.kubernetes.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.kubernetes.workload_identity_pool_id}/subject/system:serviceaccount:default:default"
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

resource "google_iam_workload_identity_pool" "kubernetes" {
  workload_identity_pool_id = "kubernetes"
  display_name              = "Kubernetes"
  description               = "Portfolio cluster workload identity pool"
}

resource "google_iam_workload_identity_pool_provider" "example" {
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
