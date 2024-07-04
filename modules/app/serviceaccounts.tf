module "file_service_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = var.app_project_name
  account_id   = "app-file-service-runner"
  display_name = "Runtime service account for app-file-service"
  description  = ""

  project_roles = [
    "roles/cloudtrace.agent"
  ]
}

module "api_service_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = var.app_project_name
  account_id   = "app-api-service-runner"
  display_name = "Runtime service account for app-api-service"
  description  = ""

  project_roles = [
    "roles/cloudsql.client",
    "roles/cloudsql.viewer",
    "roles/cloudtrace.agent"
  ]
}

module "ui_service_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = var.app_project_name
  account_id   = "app-ui-service-runner"
  display_name = "Runtime service account for app-ui-service"
  description  = ""

  project_roles = []
}

module "bastion_host_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = var.app_project_name
  account_id   = "bastion-runner"
  display_name = "Runtime service account for bastion host"
  description  = ""

  project_roles = [
    "roles/cloudsql.client"
  ]
}

resource "google_service_account_iam_binding" "bastion_host_sa_user" {
  service_account_id = module.bastion_host_service_account.name
  role               = "roles/iam.serviceAccountUser"
  members            = [var.groups["developers"]]
}

module "workflow_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = var.app_project_name
  account_id   = "workflow-sa"
  display_name = "Workflow Service Account"
  description  = ""

  project_roles = [
    "roles/eventarc.eventReceiver",
    "roles/logging.logWriter",
    "roles/run.invoker",
    "roles/storage.objectUser",
    "roles/workflows.invoker"
  ]
}

resource "google_service_account_iam_binding" "pubsub_sa_tokenCreator_binding" {
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["serviceAccount:service-508747128547@gcp-sa-pubsub.iam.gserviceaccount.com"]
  service_account_id = module.workflow_service_account.name
}
