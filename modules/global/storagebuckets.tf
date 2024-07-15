module "storage_bucket_cloud_build" {
  source = "../shared/gcp-storage-bucket"

  bucket_name_prefix = var.bucket_prefix
  bucket_name        = "${module.cicd_project.name}-cloud-build"
  environment        = var.environment
  project            = module.cicd_project.name
  region             = var.gcp_region
  storage_class      = "STANDARD"
  versioning         = false

  storageLegacyBucketReaders = []

  storageObjectViewers = []

  storageObjectUsers = []

  storageObjectAdmins = []

  storageAdmins = []

  storageObjectCreators = [module.cloud_build_service_account.sa_member]
}
