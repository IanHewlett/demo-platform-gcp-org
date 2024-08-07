variable "network_project_name" {
  description = "project name"
  type        = string
}

variable "gcp_region" {
  description = "Region for resources to be located in"
}

variable "core_subnet_cidr" {
  description = ""
  type        = string
}

variable "serverless_subnet_cidr" {
  description = ""
  type        = string
}

variable "shared_vpc_service_projects" {
  description = "Shared VPC service projects to register with this host."
  type        = set(string)
}
