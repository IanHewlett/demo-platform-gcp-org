resource "google_service_account" "app_service_account" {
  account_id   = "terraform-sa-${var.project_name}"
  display_name = "Terraform-managed."
  description  = "Privileged Terraform service account for app project"
  project      = var.project_name
}

resource "google_project_iam_member" "app_project_iam_additive" {
  for_each = var.app_roles

  project = var.project_name
  role    = each.key
  member  = "serviceAccount:${google_service_account.app_service_account.email}"
}
