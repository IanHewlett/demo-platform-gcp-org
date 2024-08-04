include "root" {
  path   = "../terragrunt.hcl"
  expose = true
}

inputs = {
  root_folder_num    = include.root.locals.root_folder_num
  global_folder_name = include.root.locals.global_folder_name
  billing_account_id = include.root.locals.billing_account_id
  cicd_project_name  = "sbxcicd-mk6a"
  groups             = include.root.locals.groups
  environment        = "global"
  bucket_prefix      = "proto-legion"
  gcp_region         = "us-central1"
}

terraform {
  source = "../modules//global"
}
