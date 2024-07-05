include "root" {
  path   = "../../terragrunt.hcl"
  expose = true
}

dependency "global" {
  config_path = ".."
}

locals {
  global_vars           = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  environment           = "${basename(get_terragrunt_dir())}"
  network_project_name  = "sbxnet-mk3a"
  security_project_name = "sbxsec-mk3a"
  app_project_names = [
    "sbxdev-mk3a"
  ]
  app_subnet_cidrs = {
    "sbxdev-mk3a" : "172.16.32.0/24"
    "sbxqa-mk3a" : "172.16.33.0/24"
  }
}

inputs = {
  billing_account_id     = include.root.locals.billing_account_id
  project_folder_id      = dependency.global.outputs.project_folder_id
  core_folder_id         = dependency.global.outputs.core_folder_id
  gcp_region             = "us-central1"
  environment            = local.environment
  network_project_name   = local.network_project_name
  security_project_name  = local.security_project_name
  core_subnet_cidr       = "172.16.34.0/24"
  serverless_subnet_cidr = "10.240.1.0/28"
  app_project_names      = local.app_project_names
  app_subnet_cidrs       = local.app_subnet_cidrs
  core_cicd_sa_email     = dependency.global.outputs.cicd_sa_email
  groups                 = local.global_vars.locals.groups
}

terraform {
  source = "../../modules//core"
}
