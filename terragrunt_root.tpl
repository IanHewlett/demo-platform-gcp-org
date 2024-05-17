locals {
  platform = "$platform"
  tfc_org = "$tfc_org"
  root_folder_num    = "$root_folder_num"
  billing_account_id = "$billing_account_id"
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  cloud {
    organization = "${local.tfc_org}"

    workspaces {
      name = "${local.platform}-${basename(get_terragrunt_dir())}"
    }
  }
}
EOF
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
}
provider "google-beta" {
}
EOF
}
