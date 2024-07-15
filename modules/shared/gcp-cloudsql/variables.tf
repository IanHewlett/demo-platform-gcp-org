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

variable "service_account" {
  type        = string
  description = ""
}

variable "instance_name" {
  type        = string
  description = "Name of the CloudSQL instance"
}

variable "database_name" {
  type        = string
  description = "Name of the database"
}

variable "private_network" {
  type        = string
  description = "Fully qualified resource name of the VPC network used by the CloudSQL instance"
}

variable "service_name" {
  type        = string
  description = "Name of the service which is using the database"
}
