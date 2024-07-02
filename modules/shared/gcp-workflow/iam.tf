data "google_storage_project_service_account" "gcs_account" {
  project = var.project_name
}

resource "google_project_iam_member" "gs_sa_pubsub_binding" {
  project = var.project_name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}
