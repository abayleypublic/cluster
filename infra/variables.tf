variable "project_id" {
  description = "The project ID to use for the Google Cloud resources."
  type        = string
  default     = "portfolio-459420"
}

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
}

variable "gcp_project_number" {
  description = "The project number of the GCP project."
  type        = string
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
