include "root" {
  path   = "../terragrunt.hcl"
  expose = true
}

locals {
  global_vars       = read_terragrunt_config("global.hcl")
  cicd_project_name = "sbxcicd-mk1b"
}

inputs = {
  root_folder_num    = include.root.locals.root_folder_num
  global_folder_name = include.root.locals.global_folder_name
  billing_account_id = include.root.locals.billing_account_id
  cicd_project_name  = local.cicd_project_name
  project_services   = local.global_vars.locals.project_services
  jit_services       = local.global_vars.locals.jit_services
  core_roles         = local.global_vars.locals.core_roles
  groups             = local.global_vars.locals.groups
  root_folder_roles  = local.global_vars.locals.root_folder_roles
  environment        = "global"
}

terraform {
  source = "../modules//global"
}
