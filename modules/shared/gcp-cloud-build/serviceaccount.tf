resource "google_service_account" "cloud_build_service_account" {
  account_id  = "terraform-sa-build-submit"
  description = "cloud build submitter service account"
  project     = var.cicd_project_name
}
