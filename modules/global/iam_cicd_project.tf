module "tf_cicd_project_iam" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.7.1"

  projects = [module.cicd_project.name]
  mode     = "authoritative"
  bindings = {
    "roles/storage.objectAdmin" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/secretmanager.secretAccessor" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/storage.admin" = [
      "serviceAccount:${module.cicd_project.number}@cloudbuild.gserviceaccount.com"
    ]
    "roles/cloudbuild.builds.editor" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/cloudbuild.builds.builder" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
    "roles/logging.logWriter" = [
      "serviceAccount:${google_service_account.core_service_account.email}"
    ]
  }
}
