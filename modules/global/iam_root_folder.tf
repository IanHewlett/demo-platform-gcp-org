resource "google_folder_iam_member" "additive_folder" {
  for_each = var.root_folder_roles

  folder = google_folder.global.id
  role   = each.key
  member = "serviceAccount:${google_service_account.core_service_account.email}"
}

resource "google_folder_iam_member" "additive_admin_group_folder_admin" {
  folder = google_folder.global.id
  role   = "roles/resourcemanager.folderAdmin"
  member = var.groups["admins"]
}

resource "google_folder_iam_member" "additive_admin_group_sa_user" {
  folder = google_folder.global.id
  role   = "roles/iam.serviceAccountUser"
  member = var.groups["admins"]
}

resource "google_folder_iam_member" "additive_admin_group_project_iam_admin" {
  folder = google_folder.global.id
  role   = "roles/resourcemanager.projectIamAdmin"
  member = var.groups["admins"]
}

resource "google_folder_iam_member" "additive_admin_group_sa_token_creator" {
  folder = google_folder.global.id
  role   = "roles/iam.serviceAccountTokenCreator"
  member = var.groups["admins"]
}

resource "google_folder_iam_member" "additive_groups_admin_viewer" {
  folder = google_folder.global.id
  role   = "roles/viewer"
  member = var.groups["admins"]
}

resource "google_folder_iam_member" "additive_groups_developer_viewer" {
  folder = google_folder.global.id
  role   = "roles/viewer"
  member = var.groups["developers"]
}

resource "google_folder_iam_member" "additive_groups_viewer_viewer" {
  folder = google_folder.global.id
  role   = "roles/viewer"
  member = var.groups["viewers"]
}
