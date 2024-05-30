resource "google_project" "this" {
  name                = var.project_name
  project_id          = var.project_name
  folder_id           = var.folder_id
  billing_account     = var.billing_account_id
  skip_delete         = false
  auto_create_network = false
}

resource "google_project_service" "enabled_services" {
  for_each = var.project_services

  project            = google_project.this.name
  service            = each.key
  disable_on_destroy = false
}

resource "google_project_default_service_accounts" "default_service_accounts" {
  project        = google_project.this.name
  action         = "DISABLE"
  restore_policy = "REVERT_AND_IGNORE_FAILURE"

  depends_on = [google_project_service.enabled_services]
}

resource "google_project_service_identity" "servicenetworking_jit_si" {
  provider = google-beta

  project = google_project.this.name
  service = "servicenetworking.googleapis.com"

  depends_on = [google_project_service.enabled_services]
}

resource "google_project_iam_member" "servicenetworking" {
  project = google_project.this.name
  role    = "roles/servicenetworking.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.servicenetworking_jit_si.email}"

  depends_on = [google_project_service.enabled_services]
}

resource "google_project_service_identity" "jit_si" {
  for_each = var.jit_services
  provider = google-beta

  project = google_project.this.name
  service = each.key

  depends_on = [google_project_service.enabled_services]
}
