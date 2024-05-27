variable "project_name" {
  type        = string
  description = "Google Project ID"
}

variable "gcp_region" {
  type        = string
  description = "Google Cloud Region"
}

variable "environment" {
  type        = string
  description = ""
}

variable "db_tier" {
  type        = string
  description = ""
}

variable "shared_network_project" {
  type        = string
  description = ""
}

variable "allocated_ip_range" {
  type        = string
  description = ""
}

variable "api_service_account" {
  type        = string
  description = ""
}
