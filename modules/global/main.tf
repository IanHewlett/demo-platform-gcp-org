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
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/compute.networkAdmin" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/logging.admin" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
  }
}
