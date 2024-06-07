variable "gcp_region" {
  description = "Region for resources to be located in"
  type        = string
}

variable "environment" {
  description = ""
  type        = string
}

variable "app_project_name" {
  description = "project name"
  type        = string
}

variable "host_vpc" {
  description = ""
  type        = string
}

variable "domains" {
  type        = list(string)
  description = "List of domain names for certificate provisioning"
}

variable "allocated_ip_range" {
  type        = string
  description = "Name of the allocated IP range used by psa"
}

variable "alert_recipients" {
  type        = list(string)
  description = "List of email alert recipients."
}
