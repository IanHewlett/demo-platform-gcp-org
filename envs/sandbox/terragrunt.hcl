include "root" {
  path   = "../../terragrunt.hcl"
  expose = true
}

dependency "global" {
  config_path = ".."
}

inputs = {
  billing_account_id     = include.root.locals.billing_account_id
  project_folder_id      = dependency.global.outputs.project_folder_id
  core_folder_id         = dependency.global.outputs.core_folder_id
  gcp_region             = "us-central1"
  environment            = "${basename(get_terragrunt_dir())}"
  network_project_name   = "sbxnet-mk3a"
  security_project_name  = "sbxsec-mk3a"
  core_subnet_cidr       = "172.16.34.0/24"
  serverless_subnet_cidr = "10.240.1.0/28"
  core_cicd_sa_email     = dependency.global.outputs.cicd_sa_email
  groups                 = include.root.locals.groups

  app_project_names = [
    "sbxdev-mk3a"
  ]

  app_subnet_cidrs = {
    "sbxdev-mk3a" : "172.16.32.0/24"
    "sbxqa-mk3a" : "172.16.33.0/24"
  }
}

terraform {
  source = "../../modules//core"
}
