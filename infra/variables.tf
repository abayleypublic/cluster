variable "project_id" {
  description = "The project ID to use for the Google Cloud resources."
  type        = string
  default     = "portfolio-459420"
}

variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "fingerprint" {}

variable "private_key_path" {}

variable "region" {
  type    = string
  default = "uk-london-1"
}