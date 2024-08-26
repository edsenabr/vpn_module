resource "google_service_account" "vpn" {
    project = var.project_id
    account_id   = "vpn-account"
    display_name = "VPN Service Account"
}