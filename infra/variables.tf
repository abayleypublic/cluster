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