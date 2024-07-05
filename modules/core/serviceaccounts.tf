module "app_cicd_service_account" {
  for_each = var.app_project_names
  source   = "../shared/gcp-service-account"

  project_id   = module.app_projects[each.key].name
  account_id   = "terraform-sa-${module.app_projects[each.key].name}"
  display_name = "Terraform-managed."
  description  = "Privileged Terraform service account for app project"

  project_roles = [
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
