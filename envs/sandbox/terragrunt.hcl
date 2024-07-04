include "root" {
  path   = "../../terragrunt.hcl"
  expose = true
}

dependency "global" {
  config_path = ".."
}

locals {
  global_vars           = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  environment           = "${basename(get_terragrunt_dir())}"
  network_project_name  = "sbxnet-mk1c"
  security_project_name = "sbxsec-mk1c"
  app_project_names = [
    "sbxdev-mk1c"
  ]
  app_subnet_cidrs = {
    "sbxdev-mk1c" : "172.16.32.0/24"
    "sbxqa-mk1c" : "172.16.33.0/24"
  }
}

inputs = {
  billing_account_id     = include.root.locals.billing_account_id
  project_folder_id      = dependency.global.outputs.project_folder_id
  core_folder_id         = dependency.global.outputs.core_folder_id
  gcp_region             = "us-central1"
  environment            = local.environment
  network_project_name   = local.network_project_name
  security_project_name  = local.security_project_name
  project_services       = local.global_vars.locals.project_services
  jit_services           = local.global_vars.locals.jit_services
  core_subnet_cidr       = "172.16.34.0/24"
  serverless_subnet_cidr = "10.240.1.0/28"
  app_project_names      = local.app_project_names
  app_subnet_cidrs       = local.app_subnet_cidrs
  core_cicd_sa_email     = dependency.global.outputs.cicd_sa_email
  groups                 = local.global_vars.locals.groups
  app_services = [
    "admin.googleapis.com",
    "apigateway.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudshell.googleapis.com",
    "compute.googleapis.com",
    "eventarc.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "iap.googleapis.com",
    "identitytoolkit.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "networkmanagement.googleapis.com",
    "orgpolicy.googleapis.com",
    "osconfig.googleapis.com",
    "pubsub.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "vpcaccess.googleapis.com",
    "workflows.googleapis.com",
    "workflowexecutions.googleapis.com",
  ]
  app_jit_services = [
    "cloudbuild.googleapis.com",
    "pubsub.googleapis.com",
    "sqladmin.googleapis.com"
  ]
  app_roles = [
    "roles/cloudscheduler.admin",
    "roles/cloudsql.admin",
    "roles/compute.instanceAdmin",
    "roles/compute.loadBalancerAdmin",
    "roles/compute.networkAdmin",
    "roles/eventarc.admin",
    "roles/iam.roleAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/monitoring.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/run.admin",
    "roles/secretmanager.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.hmacKeyAdmin",
    "roles/workflows.admin"
  ]
}

terraform {
  source = "../../modules//core"
}
