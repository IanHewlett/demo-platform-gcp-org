##
# OAuth brand data.
# Only "Organization Internal" brands can be created programmatically via API.
# Brands can only be created once for a Google Cloud project and the underlying Google API doesn't not support DELETE or PATCH methods.
# Destroying a Terraform-managed Brand will remove it from state but will not delete it from Google Cloud.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_brand
resource "google_iap_brand" "project_brand" {
  support_email     = "ihewlett@ianwhewlett.com"
  application_title = "Proto-Legion OAuth"
  project           = var.project_name
}
