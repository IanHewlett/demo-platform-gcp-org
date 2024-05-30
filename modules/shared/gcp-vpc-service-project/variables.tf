variable "host_vpc" {
  description = ""
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "project_number" {
  description = "project number"
  type        = string
}

variable "gcp_region" {
  description = "Region for resources to be located in"
  type        = string
}

variable "app_subnet_cidr" {
  description = ""
  type        = string
}

variable "project_sa_email" {
  type        = string
  description = ""
}
