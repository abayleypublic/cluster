data "mongodbatlas_federated_settings" "settings" {
  org_id = var.org_id
}

resource "mongodbatlas_federated_settings_identity_provider" "k8s_oidc" {
  federation_settings_id = data.mongodbatlas_federated_settings.settings.id
  audience               = "mongodb"
  authorization_type     = "USER"
  description            = "Kubernetes OIDC provider"
  issuer_uri             = "https://kube.austinbayley.co.uk"
  idp_type               = "WORKLOAD"
  name                   = "cluster-issuer"
  protocol               = "OIDC"
  user_claim             = "sub"
}
