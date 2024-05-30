include "root" {
  path   = "../../../terragrunt.hcl"
  expose = true
}

dependency "core" {
  config_path = ".."
}

locals {
  global_vars      = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  core_vars        = read_terragrunt_config(find_in_parent_folders("core.hcl"))
  app_vars         = read_terragrunt_config("app.hcl")
  environment      = "${basename(get_terragrunt_dir())}"
  app_project_name = "sbxdev-mk42"
}

inputs = {
  billing_account_id = include.root.locals.billing_account_id
  app_folder_id      = dependency.core.outputs.app_folder_id
  gcp_region         = local.core_vars.locals.gcp_region
  environment        = local.environment
  app_project_name   = local.app_project_name
  host_vpc           = dependency.core.outputs.host_vpc_name
  app_roles          = local.app_vars.locals.app_roles
  app_services       = local.app_vars.locals.app_services
  jit_services       = local.app_vars.locals.jit_services
  app_subnet_cidr    = local.app_vars.locals.app_subnet_cidr
  domains            = ["ianwhewlett.com"]
  allocated_ip_range = "cloudsql-psa"
  alert_recipients   = ["ian.w.hewlett@gmail.com"]
}

terraform {
  source = "../../../modules//app"
}
