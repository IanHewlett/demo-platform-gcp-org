module "app_project_iam" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.7.1"

  projects = [var.project_name]
  mode     = "additive"
  bindings = {
    "roles/iap.admin" = [
      var.groups["admins"]
    ]
    "roles/oauthconfig.editor" = [
      var.groups["admins"]
    ]
    "roles/cloudscheduler.admin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/cloudsql.admin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/compute.instanceAdmin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/compute.loadBalancerAdmin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/compute.networkAdmin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/eventarc.admin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/iam.roleAdmin" = [
      "serviceAccount:${var.core_sa_email}",
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/iam.securityAdmin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${google_service_account.app_service_account.email}",
    ]
    "roles/monitoring.admin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/run.admin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/secretmanager.admin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/storage.hmacKeyAdmin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
    "roles/workflows.admin" = [
      "serviceAccount:${google_service_account.app_service_account.email}"
    ]
  }
}
