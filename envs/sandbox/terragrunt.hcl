include "root" {
  path   = "../../terragrunt.hcl"
  expose = true
}

dependency "global" {
  config_path = ".."
}

inputs = {
  billing_account_id    = include.root.locals.billing_account_id
  project_folder_id     = dependency.global.outputs.project_folder_id
  core_folder_id        = dependency.global.outputs.core_folder_id
  network_project_name  = "sbxnet-mk5a"
  security_project_name = "sbxsec-mk5a"
  core_cicd_sa_email    = dependency.global.outputs.cicd_sa_email
  groups                = include.root.locals.groups

  app_project_names = [
    "sbxdev-mk5a"
  ]
}

terraform {
  source = "../../modules//core"
}
