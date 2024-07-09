module "file_service_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = data.google_project.app_project.name
  account_id   = "app-file-service-runner"
  display_name = "Runtime service account for app-file-service"
  description  = ""

  project_roles = [
    "roles/cloudtrace.agent"
  ]

  bindings = {}
}

module "api_service_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = data.google_project.app_project.name
  account_id   = "app-api-service-runner"
  display_name = "Runtime service account for app-api-service"
  description  = ""

  project_roles = [
    "roles/cloudsql.client",
    "roles/cloudsql.viewer",
    "roles/cloudtrace.agent"
  ]

  bindings = {}
}

module "ui_service_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = data.google_project.app_project.name
  account_id   = "app-ui-service-runner"
  display_name = "Runtime service account for app-ui-service"
  description  = ""

  project_roles = []

  bindings = {}
}

module "bastion_host_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = data.google_project.app_project.name
  account_id   = "bastion-runner"
  display_name = "Runtime service account for bastion host"
  description  = ""

  project_roles = [
    "roles/cloudsql.client"
  ]

  bindings = {
    "roles/iam.serviceAccountUser" = [var.groups["developers"]]
  }
}

module "workflow_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = data.google_project.app_project.name
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

  bindings = {
    "roles/iam.serviceAccountTokenCreator" = ["serviceAccount:service-${data.google_project.app_project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"]
  }
}

data "google_storage_project_service_account" "gcs_account" {
  project = data.google_project.app_project.name
}

resource "google_project_iam_member" "gs_sa_pubsub_binding" {
  project = data.google_project.app_project.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}
