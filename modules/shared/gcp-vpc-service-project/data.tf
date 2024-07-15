data "google_project" "app_project" {
  project_id = var.project_name
}

data "google_service_account" "app_service_account" {
  project    = var.project_name
  account_id = "terraform-sa-${var.project_name}"
}
