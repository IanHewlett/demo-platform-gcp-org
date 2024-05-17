resource "google_project" "core_project" {
  auto_create_network = false
  billing_account     = var.billing_account_id
  folder_id           = var.folder_id
  name                = var.project_name
  project_id          = var.project_name
  skip_delete         = false
}

resource "google_project_default_service_accounts" "default_service_accounts" {
  action         = "DISABLE"
  project        = google_project.core_project.name
  restore_policy = "REVERT_AND_IGNORE_FAILURE"
}

resource "google_project_service_identity" "servicenetworking" {
  provider = google-beta
  project  = google_project.core_project.name
  service  = "servicenetworking.googleapis.com"
}

resource "google_project_iam_member" "servicenetworking" {
  member  = "serviceAccount:${google_project_service_identity.servicenetworking.email}"
  project = google_project.core_project.name
  role    = "roles/servicenetworking.serviceAgent"
}

resource "google_project_service" "project_services" {
  for_each = var.project_services

  disable_dependent_services = false
  disable_on_destroy         = false
  project                    = google_project.core_project.name
  service                    = each.key
}

resource "google_project_service_identity" "cloudbuild_jit_si" {
  provider = google-beta
  project  = google_project.core_project.name
  service  = "cloudbuild.googleapis.com"
}

resource "google_project_service_identity" "secretmanager_jit_si" {
  provider = google-beta
  project  = google_project.core_project.name
  service  = "secretmanager.googleapis.com"
}
