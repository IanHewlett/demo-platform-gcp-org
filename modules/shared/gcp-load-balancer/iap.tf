resource "google_iap_brand" "project_brand" {
  support_email     = "ihewlett@ianwhewlett.com"
  application_title = "Proto-Legion OAuth"
  project           = var.project_name
}

resource "google_iap_client" "iap_client" {
  display_name = "Terraform-managed IAP client"
  brand        = var.oauth_brand
}
