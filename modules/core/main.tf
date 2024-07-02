module "network_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = var.core_folder_id
  project_name       = var.network_project_name
  project_services   = var.project_services
  jit_services       = var.jit_services
}

module "security_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = var.core_folder_id
  project_name       = var.security_project_name
  project_services   = var.project_services
  jit_services       = var.jit_services
}

resource "google_folder" "app" {
  display_name = "app"
  parent       = var.core_folder_id
}

module "app_projects" {
  for_each = var.app_project_names
  source   = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = google_folder.app.id
  project_name       = each.key
  project_services   = var.app_services
  jit_services       = var.app_jit_services
}

module "app_cicd_service_account" {
  for_each = var.app_project_names
  source   = "../shared/gcp-service-account"

  project_id    = module.app_projects[each.key].name
  account_id    = "terraform-sa-${module.app_projects[each.key].name}"
  display_name  = "Terraform-managed."
  description   = "Privileged Terraform service account for app project"
  project_roles = var.app_roles
}

module "network_project_iam" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.7.1"

  projects = [module.network_project.name]
  mode     = "authoritative"
  bindings = {
    "roles/compute.networkAdmin" = [
      var.groups["admins"]
    ]
    "roles/compute.networkViewer" = values(module.app_cicd_service_account)[*].sa_member
    "roles/compute.securityAdmin" = [
      var.groups["admins"],
      "serviceAccount:${var.core_cicd_sa_email}"
    ]
    "roles/vpcaccess.admin" = [
      "serviceAccount:${var.core_cicd_sa_email}"
    ]
    "roles/vpcaccess.user" = [for number in values(module.app_projects)[*].number : "serviceAccount:service-${number}@serverless-robot-prod.iam.gserviceaccount.com"]
  }
}

module "app_folder_iam" {
  for_each = var.app_project_names
  source   = "terraform-google-modules/iam/google//modules/folders_iam"
  version  = "7.7.1"

  folders = [google_folder.app.id]
  mode    = "authoritative"
  bindings = {
    "roles/storage.admin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/logging.admin" = [
      "serviceAccount:${var.core_cicd_sa_email}",
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
  }
}

module "app_project_iam" {
  for_each = var.app_project_names
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "7.7.1"

  projects = [module.app_projects[each.key].name]
  mode     = "additive"

  bindings = {
    "roles/iap.admin" = [
      var.groups["admins"]
    ]
    "roles/oauthconfig.editor" = [
      var.groups["admins"]
    ]
    "roles/cloudscheduler.admin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/cloudsql.admin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/compute.instanceAdmin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/compute.loadBalancerAdmin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/compute.networkAdmin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/eventarc.admin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/iam.roleAdmin" = [
      "serviceAccount:${var.core_cicd_sa_email}",
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/iam.securityAdmin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}",
    ]
    "roles/monitoring.admin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/run.admin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/secretmanager.admin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/storage.hmacKeyAdmin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
    "roles/workflows.admin" = [
      "serviceAccount:${module.app_cicd_service_account[each.key].email}"
    ]
  }
}

module "shared_vpc" {
  source = "../shared/gcp-vpc-shared"

  network_project_name   = module.network_project.name
  security_project_name  = module.security_project.name
  gcp_region             = var.gcp_region
  core_subnet_cidr       = var.core_subnet_cidr
  serverless_subnet_cidr = var.serverless_subnet_cidr
}

module "vpc_service_project" {
  for_each = module.app_projects
  source   = "../shared/gcp-vpc-service-project"

  project_name     = module.app_projects[each.key].name
  project_number   = module.app_projects[each.key].number
  gcp_region       = var.gcp_region
  host_vpc         = module.shared_vpc.host_vpc_name
  app_subnet_cidr  = var.app_subnet_cidrs[module.app_projects[each.key].name]
  project_sa_email = module.app_cicd_service_account[each.key].email
}
