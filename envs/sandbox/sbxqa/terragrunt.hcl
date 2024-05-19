include "root" {
  path   = "../../../terragrunt.hcl"
  expose = true
}

dependency "core" {
  config_path = ".."
}

locals {
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  core_vars = read_terragrunt_config(find_in_parent_folders("core.hcl"))
  app_vars = read_terragrunt_config("app.hcl")
  app_project_name = "sbxqa-mk31"
}

inputs = {
  billing_account_id = include.root.locals.billing_account_id
  app_folder_id = dependency.core.outputs.app_folder_id
  region = local.core_vars.locals.region
  app_project_name = local.app_project_name
  host_vpc = dependency.core.outputs.host_vpc_name
  app_roles = local.app_vars.locals.app_roles
  app_services = local.app_vars.locals.app_services
  app_subnet = local.app_vars.locals.app_subnet
}

terraform {
  source = "../../../modules//app"
}
