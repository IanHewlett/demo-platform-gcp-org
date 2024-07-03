module "bastion_host_service_account" {
  source = "../gcp-service-account"

  project_id   = var.project
  account_id   = "bastion-runner"
  display_name = "Runtime service account for bastion host"
  description  = ""

  project_roles = var.service_account_roles
}

resource "google_service_account_iam_binding" "bastion_host_sa_user" {
  service_account_id = module.bastion_host_service_account.name
  role               = "roles/iam.serviceAccountUser"
  members            = var.bastion_host_accessors
}
