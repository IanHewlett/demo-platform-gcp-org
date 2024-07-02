variable "project_name" {
  type        = string
  description = "Google Project ID"
}

variable "gcp_region" {
  type        = string
  description = "Google Cloud Region"
}

variable "cloud_run_service_name" {
  type        = string
  description = ""
}

variable "service_account_roles" {
  type        = list(string)
  description = "Roles for the runtime service account"
}
