#!/usr/bin/env just --justfile
set dotenv-load
KEEP_TERRAGRUNT_CACHE := "false"

_default:
  @just --list

#_terragrunt-run-all action module *flags:
#  terragrunt run-all {{action}} {{flags}} --terragrunt-working-dir {{module}}

_terragrunt-run action module *flags:
  terragrunt {{action}} {{flags}} --terragrunt-working-dir {{module}}

# Remove old terragrunt hcl file, old terragrunt cache, terragrunt and terraform old files in the terraform directory
clean:
  @rm -rf ./terragrunt.hcl
  @{{KEEP_TERRAGRUNT_CACHE}} || cd ./envs && ( find . -type f -name '.terraform*' && find . -type d -name '.terragrunt*' ) | xargs rm -rf

# Write the Values in Terragrunt file
template: clean
  platform="$PLATFORM" \
  tfc_org="$TFC_ORG" \
  root_folder_num="$GCP_ROOT_FOLDER_NUM" \
  billing_account_id="$GCP_BILLING_ACCOUNT_ID" \
  envsubst < ./terragrunt_root.tpl > terragrunt.hcl

format module: template
  just _terragrunt-run fmt {{module}}

validate module: (format module)
  just _terragrunt-run validate {{module}} --terragrunt-non-interactive

plan module: (validate module)
  just _terragrunt-run plan {{module}} --terragrunt-non-interactive

apply module: (plan module)
  just _terragrunt-run apply {{module}} --terragrunt-non-interactive

destroy module: (validate module)
  just _terragrunt-run destroy {{module}} --terragrunt-non-interactive
