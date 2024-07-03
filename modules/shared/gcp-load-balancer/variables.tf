variable "project_name" {
  type        = string
  description = "Google Project ID"
}

variable "domains" {
  type        = list(string)
  description = "List of domain names for certificate provisioning"
}

variable "gcp_region" {
  type        = string
  description = "Google Cloud Region"
}

variable "environment" {
  description = ""
  type        = string
}

variable "oauth_brand" {
  type        = string
}

variable "cloud_run_service_name_api" {
  type        = string
  description = "Google Cloud Run service name"
}

variable "cloud_run_service_name_ui" {
  type        = string
  description = "Google Cloud Run service name"
}
