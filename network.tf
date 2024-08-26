resource "google_compute_address" "vpn" {
  project = var.project_id
  name = "vpn-server-address"
  region = var.region
}

resource "google_compute_firewall" "vpn" {
  project = var.project_id
  name    = "vpn-server-ingress"
  network =  var.vpc.self_link
  target_tags = ["vpn"]
  allow {
    protocol = "udp"
    ports    = ["68","500", "4500"]
  }
  source_ranges = var.allowed_ips
}