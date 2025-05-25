resource "oci_kms_vault" "secret_vault" {
  compartment_id = oci_identity_compartment.cluster.id
  display_name   = "secret_vault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "master_encryption_key" {
  compartment_id = oci_identity_compartment.cluster.id
  display_name   = "master_encryption_key"
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  management_endpoint = "https://eruckcfxaaarq-management.kms.uk-london-1.oraclecloud.com"
}

resource "oci_vault_secret" "argocd_github_repo_private_key" {
  compartment_id = oci_identity_compartment.cluster.id
  key_id         = oci_kms_key.master_encryption_key.id
  secret_name    = "argocd_github_repo_private_key"
  vault_id       = oci_kms_vault.secret_vault.id

  secret_content {
    # This is apparently the only content type available but is not enforced
    # for new secret versions which is what this will be used for...strange
    content_type = "BASE64"

    # Apparently a value is required too
    # This is the base64 encoded value of "REPLACE_ME"
    content = "UkVQTEFDRV9NRQ=="
  }
}

resource "oci_vault_secret" "argocd_github_client_secret" {
  compartment_id = oci_identity_compartment.cluster.id
  key_id         = oci_kms_key.master_encryption_key.id
  secret_name    = "argocd_github_client_secret"
  vault_id       = oci_kms_vault.secret_vault.id

  secret_content {
    content_type = "BASE64"
    content      = "UkVQTEFDRV9NRQ=="
  }
}

resource "oci_vault_secret" "k3s_ca_certificate" {
  compartment_id = oci_identity_compartment.cluster.id
  key_id         = oci_kms_key.master_encryption_key.id
  secret_name    = "k3s_ca_certificate"
  vault_id       = oci_kms_vault.secret_vault.id

  secret_content {
    content_type = "BASE64"
    content      = "UkVQTEFDRV9NRQ=="
  }
}

resource "oci_vault_secret" "k3s_client_certificate" {
  compartment_id = oci_identity_compartment.cluster.id
  key_id         = oci_kms_key.master_encryption_key.id
  secret_name    = "k3s_client_certificate"
  vault_id       = oci_kms_vault.secret_vault.id

  secret_content {
    content_type = "BASE64"
    content      = "UkVQTEFDRV9NRQ=="
  }
}

resource "oci_vault_secret" "k3s_client_key" {
  compartment_id = oci_identity_compartment.cluster.id
  key_id         = oci_kms_key.master_encryption_key.id
  secret_name    = "k3s_client_key"
  vault_id       = oci_kms_vault.secret_vault.id

  secret_content {
    content_type = "BASE64"
    content      = "UkVQTEFDRV9NRQ=="
  }
}

resource "oci_vault_secret" "cloudflare_api_key" {
  compartment_id = oci_identity_compartment.cluster.id
  key_id         = oci_kms_key.master_encryption_key.id
  secret_name    = "cloudflare_api_key"
  vault_id       = oci_kms_vault.secret_vault.id

  secret_content {
    content_type = "BASE64"
    content      = "UkVQTEFDRV9NRQ=="
  }
}

resource "oci_vault_secret" "kubeconfig" {
  compartment_id = var.compartment_id
  secret_name    = "kubeconfig"
  vault_id       = oci_kms_vault.secret_vault.id
  key_id         = oci_kms_key.master_encryption_key.id
  description    = "Kubeconfig for cluster access"

  secret_content {
    content_type = "BASE64"
    content      = "UkVQTEFDRV9NRQ=="
  }
}

resource "oci_vault_secret" "jwks" {
  compartment_id = var.compartment_id
  secret_name    = "jwks"
  vault_id       = oci_kms_vault.secret_vault.id
  key_id         = oci_kms_key.master_encryption_key.id
  description    = "JWKS for the cluster"

  secret_content {
    content_type = "BASE64"
    content      = "UkVQTEFDRV9NRQ=="
  }
}
