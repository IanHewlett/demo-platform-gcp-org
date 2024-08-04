include "root" {
  path   = "../../../terragrunt.hcl"
  expose = true
}

dependency "core" {
  config_path = ".."
}

inputs = {
  gcp_region             = "us-central1"
  network_project_name   = "sbxnet-mk6a"
  security_project_name  = "sbxsec-mk6a"
  core_subnet_cidr       = "172.16.34.0/24"
  serverless_subnet_cidr = "10.240.1.0/28"

  app_project_names = [
    "sbxdev-mk6a"
  ]

  app_subnet_cidrs = {
    "sbxdev-mk6a" : "172.16.32.0/24"
    "sbxqa-mk6a" : "172.16.33.0/24"
  }
}

terraform {
  source = "../../../modules//core-net"
}
