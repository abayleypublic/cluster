variable "project_id" {
  description = "The ID of the GCP project in which the resources will be created."
  type        = string
}

variable "region" {
  description = "The region in which the GCP resources will be created."
  type        = string
  default     = "europe-west2"
}
