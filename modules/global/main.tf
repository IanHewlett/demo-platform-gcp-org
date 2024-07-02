resource "google_folder" "global" {
  display_name = var.global_folder_name
  parent       = var.root_folder_num
}

module "cicd_project" {
  source = "../shared/gcp-project"

  billing_account_id = var.billing_account_id
  folder_id          = google_folder.global.id
  project_name       = var.cicd_project_name
  project_services   = var.project_services
  jit_services       = var.jit_services
}

module "core_cicd_service_account" {
  source = "../shared/gcp-service-account"

  project_id    = module.cicd_project.name
  account_id    = "terraform-sa-core"
  display_name  = "Terraform-managed."
  description   = "Privileged Core Terraform service account"
  project_roles = var.core_roles
}

resource "google_folder_iam_member" "additive_folder" {
  for_each = var.root_folder_roles

  folder = google_folder.global.id
  role   = each.key
  member = "serviceAccount:${module.core_cicd_service_account.email}"
}

module "global_folder_iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "7.7.1"

  folders = [google_folder.global.id]
  mode    = "additive"
  bindings = {
    "roles/resourcemanager.folderAdmin" = [
      var.groups["admins"]
    ]
    "roles/iam.serviceAccountUser" = [
      var.groups["admins"]
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      var.groups["admins"]
    ]
    "roles/iam.serviceAccountTokenCreator" = [
      var.groups["admins"]
    ]
    "roles/viewer" = [
      var.groups["viewers"],
      var.groups["developers"],
      var.groups["admins"]
    ]
  }
}

module "tf_cicd_project_iam" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.7.1"

  projects = [module.cicd_project.name]
  mode     = "authoritative"
  bindings = {
    "roles/storage.objectAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/secretmanager.secretAccessor" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/storage.admin" = [
      "serviceAccount:${module.cicd_project.number}@cloudbuild.gserviceaccount.com"
    ]
    "roles/cloudbuild.builds.editor" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/cloudbuild.builds.builder" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/logging.logWriter" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
  }
}

module "cloud_build" {
  source = "../shared/gcp-cloud-build"

  cicd_project_name = module.cicd_project.name
}

resource "google_folder" "core" {
  display_name = var.environment
  parent       = google_folder.global.id
}

module "core_folder_iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "7.7.1"

  folders = [google_folder.core.id]
  mode    = "authoritative"

  bindings = {
    "roles/storage.admin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/compute.networkAdmin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
    "roles/logging.admin" = [
      "serviceAccount:${module.core_cicd_service_account.email}"
    ]
  }
}
