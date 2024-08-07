include "root" {
  path   = "../../../../terragrunt.hcl"
  expose = true
}

dependency "core" {
  config_path = ".."
}

locals {
  global_vars      = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  environment      = "${basename(get_terragrunt_dir())}"
  app_project_name = "sbxqa-mk53"
}

inputs = {
  gcp_region         = "us-central1"
  environment        = local.environment
  app_project_name   = local.app_project_name
  host_vpc           = dependency.core.outputs.host_vpc_name
  domains            = ["ianwhewlett.com"]
  allocated_ip_range = "cloudsql-psa"
  alert_recipients   = ["ian.w.hewlett@gmail.com"]
}

terraform {
  source = "../../../../modules//app"
}
