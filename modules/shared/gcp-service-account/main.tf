resource "google_service_account" "this" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
}

resource "google_project_iam_member" "roles" {
  for_each = toset(var.project_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.this.email}"
}

resource "google_service_account_iam_binding" "service_account_iam_authoritative" {
  for_each = var.bindings

  service_account_id = google_service_account.this.name
  role               = each.key
  members            = each.value
}
