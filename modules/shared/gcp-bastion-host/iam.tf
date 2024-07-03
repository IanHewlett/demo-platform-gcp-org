resource "google_project_iam_member" "compute_viewer" {
  for_each = toset(var.bastion_host_accessors)

  project = var.project
  role    = "roles/compute.viewer"
  member  = each.value
}

resource "google_iap_tunnel_instance_iam_binding" "bastion_host_tunneler" {
  project  = var.project
  zone     = google_compute_instance.bastion_host.zone
  instance = google_compute_instance.bastion_host.name
  role     = "roles/iap.tunnelResourceAccessor"
  members  = var.bastion_host_accessors
}

resource "google_compute_instance_iam_member" "bastion_host_admin" {
  for_each = toset(var.bastion_host_accessors)

  project       = var.project
  zone          = google_compute_instance.bastion_host.zone
  instance_name = google_compute_instance.bastion_host.name
  role          = "roles/compute.instanceAdmin.v1"
  member        = each.value
}
