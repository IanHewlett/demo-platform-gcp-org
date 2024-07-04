resource "google_storage_bucket_iam_binding" "cloud_build_bucket_iam" {
  bucket = google_storage_bucket.cloud_build_bucket.name
  role   = "roles/storage.objectCreator"

  members = [
    "serviceAccount:${google_service_account.cloud_build_service_account.email}",
  ]
}
