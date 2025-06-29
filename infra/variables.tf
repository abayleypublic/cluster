variable "tenancy_ocid" {
  description = "Oracle Cloud tenancy OCID."
  type        = string
}

variable "user_ocid" {
  description = "Oracle Cloud user OCID."
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the Oracle Cloud user."
  type        = string
}

variable "private_key_path" {
  description = "Oracle Cloud private key."
  type        = string
}

variable "region" {
  description = "Oracle Cloud region."
  type        = string
  default     = "uk-london-1"
}

variable "cloudflare_api_key" {
  description = "Cloudflare API key with permissions to manage DNS records."
  type        = string
}

variable "gcp_project_id" {
  description = "The ID of the GCP project in which the resources will be created."
  type        = string
  default     = "portfolio-463406"
}

variable "gcp_project_number" {
  description = "The project number of the GCP project."
  type        = string
  default     = "416469577734"
}

variable "mongodb_atlas_public_key" {
  description = "Public key for MongoDB Atlas API."
  type        = string
}

variable "mongodb_atlas_private_key" {
  description = "Private key for MongoDB Atlas API."
  type        = string
}

variable "mongodb_atlas_org_id" {
  description = "MongoDB Atlas organization ID."
  type        = string
}

variable "auth0_domain" {
  description = "Auth0 domain."
  type        = string
  default     = "dev-hoo0x1gbvzrm2jd2.uk.auth0.com"
}

variable "auth0_client_id" {
  description = "Auth0 client ID."
  type        = string
}

variable "auth0_client_secret" {
  description = "Auth0 client secret."
  type        = string
}
