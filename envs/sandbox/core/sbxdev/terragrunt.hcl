include "root" {
  path   = "../../../../terragrunt.hcl"
  expose = true
}

dependency "core-net" {
  config_path = ".."
}

inputs = {
  gcp_region         = "us-central1"
  environment        = "${basename(get_terragrunt_dir())}"
  app_project_name   = "sbxdev-mk5a"
  host_vpc           = dependency.core-net.outputs.host_vpc_name
  app_subnet         = "sbxdev-mk5a-subnet"
  domains            = ["ianwhewlett.com"]
  allocated_ip_range = "cloudsql-psa"
  alert_recipients   = ["ian.w.hewlett@gmail.com"]
  groups             = include.root.locals.groups
  storage_users      = []
  bucket_prefix      = "proto-legion"
}

terraform {
  source = "../../../../modules//app"
}
