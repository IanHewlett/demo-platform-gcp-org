resource "google_storage_bucket_iam_binding" "storage_legacy_bucket_readers" {
  bucket  = google_storage_bucket.this.name
  role    = "roles/storage.legacyBucketReader"
  members = var.storageLegacyBucketReaders
}

resource "google_storage_bucket_iam_binding" "storage_object_viewers" {
  bucket  = google_storage_bucket.this.name
  role    = "roles/storage.objectViewer"
  members = var.storageObjectViewers
}

resource "google_storage_bucket_iam_binding" "storage_object_users" {
  bucket  = google_storage_bucket.this.name
  role    = "roles/storage.objectUser"
  members = var.storageObjectUsers
}

resource "google_storage_bucket_iam_binding" "storage_object_admins" {
  bucket  = google_storage_bucket.this.name
  role    = "roles/storage.objectAdmin"
  members = var.storageObjectAdmins
}

resource "google_storage_bucket_iam_binding" "storage_admins" {
  bucket  = google_storage_bucket.this.name
  role    = "roles/storage.admin"
  members = var.storageAdmins
}
