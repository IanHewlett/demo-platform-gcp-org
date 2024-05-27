resource "google_service_account" "cloud_build_service_account" {
  account_id  = "terraform-sa-build-submit"
  description = "cloud build submitter service account"
  project     = var.cicd_project_name
}

resource "google_storage_bucket" "cloud_build_bucket" {
  name                        = "${var.cicd_project_name}-cloud-build"
  location                    = "US-CENTRAL1"
  force_destroy               = true
  uniform_bucket_level_access = true
  project                     = var.cicd_project_name
}

resource "google_storage_bucket_iam_binding" "cloud_build_bucket_iam" {
  bucket = google_storage_bucket.cloud_build_bucket.name
  role   = "roles/storage.objectCreator"

  members = [
    "serviceAccount:${google_service_account.cloud_build_service_account.email}",
  ]
}
