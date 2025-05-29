resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Kubernetes Service Account"
}

resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.kubernetes.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${google_service_account.kubernetes.email}"
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
