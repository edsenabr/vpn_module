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

resource "google_compute_firewall" "vpn_egress" {
  project = var.project_id
  name    = "vpn-server-egress"
  network =  var.vpc.self_link
  allow {
    protocol = "all"
  }
  source_tags = ["vpn"]
  priority = 999
  destination_ranges = split(",", var.vpc_cidr)
  
}

resource "google_compute_route" "vpn" {
  name         = "vpn-server-route"
  dest_range   = var.vpn_cidr
  network      = var.vpc.self_link
  next_hop_instance = google_compute_instance.vpn_server.id
  priority     = 999
}