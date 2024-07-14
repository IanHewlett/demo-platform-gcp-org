module "core_cicd_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = module.cicd_project.name
  account_id   = "terraform-sa-core"
  display_name = "Terraform-managed."
  description  = "Privileged Core Terraform service account"

  project_roles = [
    "roles/cloudbuild.builds.builder",
    "roles/cloudbuild.builds.editor",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/resourcemanager.projectIamAdmin",
    "roles/secretmanager.secretAccessor",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.objectAdmin"
  ]

  bindings = {}
}

resource "google_project_iam_member" "cloudbuild_member" {
  project = module.cicd_project.name
  role    = "roles/storage.admin"
  member  = "serviceAccount:${module.cicd_project.number}@cloudbuild.gserviceaccount.com"
}

module "cloud_build_service_account" {
  source = "../shared/gcp-service-account"

  project_id   = module.cicd_project.name
  account_id   = "terraform-sa-build-submit"
  display_name = "Terraform-managed."
  description  = "cloud build submitter service account"

  project_roles = []

  bindings = {}
}
