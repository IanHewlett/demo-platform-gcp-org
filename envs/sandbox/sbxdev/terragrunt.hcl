include "root" {
  path   = "../../../terragrunt.hcl"
  expose = true
}

dependency "core" {
  config_path = ".."
}

locals {
  environment      = "${basename(get_terragrunt_dir())}"
  app_project_name = "sbxdev-mk3a"
}

inputs = {
  gcp_region         = "us-central1"
  environment        = local.environment
  app_project_name   = local.app_project_name
  host_vpc           = dependency.core.outputs.host_vpc_name
  app_subnet         = "${local.app_project_name}-subnet"
  domains            = ["ianwhewlett.com"]
  allocated_ip_range = "cloudsql-psa"
  alert_recipients   = ["ian.w.hewlett@gmail.com"]
  groups             = include.root.locals.groups
  storage_users      = []
}

terraform {
  source = "../../../modules//app"
}
