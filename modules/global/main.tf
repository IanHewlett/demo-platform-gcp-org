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

resource "google_service_account" "core_service_account" {
  account_id   = "terraform-sa-${module.cicd_project.name}"
  display_name = "Terraform-managed."
  description  = "Privileged Core Terraform service account"
  project      = module.cicd_project.name
}

resource "google_project_iam_binding" "project_iam_authoritative" {
  for_each = var.core_roles

  project = module.cicd_project.name
  role    = each.key

  members = [
    "serviceAccount:${google_service_account.core_service_account.email}"
  ]
}

module "cloud_build" {
  source = "../shared/gcp-cloud-build"

  cicd_project_name = module.cicd_project.name
}
