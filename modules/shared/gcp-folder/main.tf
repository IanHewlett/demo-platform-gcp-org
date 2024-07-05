resource "google_folder" "this" {
  display_name = var.folder_name
  parent       = var.parent_folder_id
}

resource "google_folder_iam_binding" "folder_iam_authoritative" {
  for_each = var.bindings

  folder  = google_folder.this.id
  role    = each.key
  members = each.value
}
