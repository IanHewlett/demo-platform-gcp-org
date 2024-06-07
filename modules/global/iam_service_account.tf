resource "google_service_account" "core_service_account" {
  account_id   = "terraform-sa-core"
  display_name = "Terraform-managed."
  description  = "Privileged Core Terraform service account"
  project      = module.cicd_project.name
}

resource "google_project_iam_binding" "project_iam_authoritative" {
  for_each = var.core_roles

  project = module.cicd_project.name
  role    = each.key

  members = [
    "serviceAccount:${google_service_account.core_service_account.email}"
  ]
}
