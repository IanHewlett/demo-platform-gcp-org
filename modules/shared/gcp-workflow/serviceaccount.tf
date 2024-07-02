module "workflow_service_account" {
  source = "../gcp-service-account"

  project_id   = var.project_name
  region       = var.region
  account_id   = "workflow-sa"
  display_name = "Workflow Service Account"
  description  = ""

  project_roles = var.service_account_roles
}

resource "google_service_account_iam_binding" "pubsub_sa_tokenCreator_binding" {
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"]
  service_account_id = module.workflow_service_account.name
}
