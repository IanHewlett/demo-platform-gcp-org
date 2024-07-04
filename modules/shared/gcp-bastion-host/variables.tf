variable "bastion_host_accessors" {
  type        = list(string)
  description = "List of users who are able to ssh into the bastion host"
}

variable "region" {
  type = string
}

variable "environment" {
  type        = string
  description = "application environment"
}

variable "api_db_config" {
  type        = map(string)
  description = "Config values to connect to the API database"
}

variable "private_network" {
  type        = string
  description = "Fully qualified resource name of the VPC network"
}

variable "project" {
  type        = string
  description = "Google Cloud project ID"
}

variable "subnet" {
  type        = string
  description = "Fully qualified resource name of the app-environment subnet"
}

variable "bastion_host_sa" {
  type = string
}
