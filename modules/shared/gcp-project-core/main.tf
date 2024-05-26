resource "google_project" "core_project" {
  name                = var.project_name
  project_id          = var.project_name
  folder_id           = var.folder_id
  billing_account     = var.billing_account_id
  skip_delete         = false
  auto_create_network = false
}

resource "google_project_default_service_accounts" "default_service_accounts" {
  project        = google_project.core_project.name
  action         = "DISABLE"
  restore_policy = "REVERT_AND_IGNORE_FAILURE"
}

resource "google_project_service_identity" "servicenetworking" {
  provider = google-beta
  service  = "servicenetworking.googleapis.com"
  project  = google_project.core_project.name
}

resource "google_project_iam_member" "servicenetworking" {
  member  = "serviceAccount:${google_project_service_identity.servicenetworking.email}"
  role    = "roles/servicenetworking.serviceAgent"
  project = google_project.core_project.name
}

resource "google_project_service" "project_services" {
  for_each = var.project_services

  service                    = each.key
  project                    = google_project.core_project.name
  disable_on_destroy         = false
}

resource "google_project_service_identity" "cloudbuild_jit_si" {
  provider = google-beta
  service  = "cloudbuild.googleapis.com"
  project  = google_project.core_project.name
}

resource "google_project_service_identity" "secretmanager_jit_si" {
  provider = google-beta
  service  = "secretmanager.googleapis.com"
  project  = google_project.core_project.name
}
