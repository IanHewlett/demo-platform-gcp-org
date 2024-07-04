resource "google_storage_bucket" "cloud_build_bucket" {
  project                     = var.cicd_project_name
  name                        = "${var.cicd_project_name}-cloud-build"
  location                    = "US-CENTRAL1"
  force_destroy               = true
  uniform_bucket_level_access = true
}
