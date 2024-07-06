locals {
  platform           = "$platform"
  global_folder_name = "$global_folder_name"
  tfc_org            = "$tfc_org"
  root_folder_num    = "$root_folder_num"
  billing_account_id = "$billing_account_id"

  groups = {
    "admins"     = "group:iwh_access_gcp_app_admins@ianwhewlett.com",
    "developers" = "group:iwh_access_gcp_app_developers@ianwhewlett.com",
    "viewers"    = "group:iwh_access_gcp_app_viewers@ianwhewlett.com"
  }
}

generate "remote_state" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
}
provider "google-beta" {
}
EOF
}
