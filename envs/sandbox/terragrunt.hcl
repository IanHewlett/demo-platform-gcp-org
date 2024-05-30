include "root" {
  path   = "../../terragrunt.hcl"
  expose = true
}

dependency "global" {
  config_path = ".."
}

locals {
  global_vars           = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  core_vars             = read_terragrunt_config("core.hcl")
  environment           = "${basename(get_terragrunt_dir())}"
  network_project_name  = "sbxnet-mk42"
  security_project_name = "sbxsec-mk42"
}

inputs = {
  billing_account_id     = include.root.locals.billing_account_id
  project_folder_id      = dependency.global.outputs.project_folder_id
  gcp_region             = local.core_vars.locals.gcp_region
  environment            = local.environment
  network_project_name   = local.network_project_name
  security_project_name  = local.security_project_name
  project_services       = local.global_vars.locals.project_services
  jit_services           = local.core_vars.locals.jit_services
  core_subnet_cidr       = local.core_vars.locals.core_subnet_cidr
  serverless_subnet_cidr = local.core_vars.locals.serverless_subnet_cidr
}

terraform {
  source = "../../modules//core"
}
