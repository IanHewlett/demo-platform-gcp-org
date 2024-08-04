##
# Contains the data that describes an Identity Aware Proxy owned client.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_client
resource "google_iap_client" "iap_client" {
  display_name = "Terraform-managed IAP client"
  brand        = "projects/${var.project_number}/brands/${var.project_number}"
}
