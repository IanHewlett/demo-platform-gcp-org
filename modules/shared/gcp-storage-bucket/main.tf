resource "google_storage_bucket" "this" {
  name                        = "${var.bucket_name_prefix}-${var.environment}-${var.bucket_name}"
  project                     = var.project
  force_destroy               = false
  uniform_bucket_level_access = true
  location                    = var.region
  public_access_prevention    = "enforced"
  storage_class               = var.storage_class

  versioning {
    enabled = var.versioning
  }
}
