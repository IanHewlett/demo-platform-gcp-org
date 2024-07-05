resource "google_project_iam_binding" "project_iam_authoritative" {
  for_each = var.bindings

  project = google_project.this.name
  role    = each.key
  members = each.value
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
