include "root" {
  path   = "../terragrunt.hcl"
  expose = true
}

locals {
  global_vars       = read_terragrunt_config("global.hcl")
  cicd_project_name = "sbxcicd-mk3a"
}

inputs = {
  root_folder_num    = include.root.locals.root_folder_num
  global_folder_name = include.root.locals.global_folder_name
  billing_account_id = include.root.locals.billing_account_id
  cicd_project_name  = local.cicd_project_name
  groups             = local.global_vars.locals.groups
  environment        = "global"
}

terraform {
  source = "../modules//global"
}
