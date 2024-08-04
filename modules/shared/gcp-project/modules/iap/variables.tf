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

variable "cloud_run_services" {
  type = set(string)
}

variable "security_policy_name" {
  type = string
}
