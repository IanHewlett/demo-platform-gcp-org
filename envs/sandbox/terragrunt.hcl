include "root" {
  path   = "../../terragrunt.hcl"
  expose = true
}

dependency "global" {
  config_path = ".."
}

inputs = {
  billing_account_id      = include.root.locals.billing_account_id
  project_folder_id       = dependency.global.outputs.project_folder_id
  core_folder_id          = dependency.global.outputs.core_folder_id
  monitoring_project_name = "sbxmon-mk6a"
  network_project_name    = "sbxnet-mk6a"
  security_project_name   = "sbxsec-mk6a"
  core_cicd_sa_email      = dependency.global.outputs.cicd_sa_email
  groups                  = include.root.locals.groups

  app_project_names = [
    "sbxdev-mk6a"
  ]
}

terraform {
  source = "../../modules//core"
}
