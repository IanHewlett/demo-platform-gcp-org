include "root" {
  path   = "../../../terragrunt.hcl"
  expose = true
}

dependency "core" {
  config_path = ".."
}

inputs = {
  gcp_region         = "us-central1"
  environment        = "${basename(get_terragrunt_dir())}"
  app_project_name   = "sbxdev-mk4a"
  host_vpc           = dependency.core.outputs.host_vpc_name
  app_subnet         = "sbxdev-mk4a-subnet"
  domains            = ["ianwhewlett.com"]
  allocated_ip_range = "cloudsql-psa"
  alert_recipients   = ["ian.w.hewlett@gmail.com"]
  groups             = include.root.locals.groups
  storage_users      = []
  bucket_prefix      = "proto-legion"
}

terraform {
  source = "../../../modules//app"
}
