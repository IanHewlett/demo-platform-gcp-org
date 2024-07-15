variable "network_project_name" {
  description = "project name"
  type        = string
}

variable "security_project_name" {
  description = "project name"
  type        = string
}

variable "gcp_region" {
  description = "Region for resources to be located in"
  type        = string
}

variable "core_subnet_cidr" {
  description = ""
  type        = string
}

variable "serverless_subnet_cidr" {
  description = ""
  type        = string
}

variable "app_project_names" {
  description = ""
  type        = list(string)
}

variable "app_subnet_cidrs" {
  type = map(string)
}
