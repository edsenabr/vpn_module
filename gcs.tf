data "template_file" "ipsec_conf" {
  template = file("${path.module}/templates/ipsec.conf.tpl")
  vars = {
    left_subnet = var.vpc_cidr
    vpn_subnet = var.vpn_cidr
  }
}

data "template_file" "rules_v4" {
  template = file("${path.module}/templates/rules.v4.tpl")
  vars = {
    vpn_subnet = var.vpn_cidr
  }
}

resource "google_storage_bucket" "config_files" {
  name          = var.project_id
  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
  public_access_prevention = "enforced"
}

resource "google_storage_bucket_iam_member" "vpn" {
  bucket = google_storage_bucket.config_files.name
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.vpn.email}"
}

resource "google_storage_bucket_object" "ipsec_conf" {
  name   = "ipsec.conf"
  content = data.template_file.ipsec_conf.rendered
  bucket = google_storage_bucket.config_files.name
}

resource "google_storage_bucket_object" "rules_v4" {
  name   = "rules.v4"
  content = data.template_file.rules_v4.rendered
  bucket = google_storage_bucket.config_files.name
}

resource "google_storage_bucket_object" "ca_cert" {
  name   = "ca.crt"
  content = tls_self_signed_cert.ca_cert.cert_pem
  bucket = google_storage_bucket.config_files.name
}

resource "google_storage_bucket_object" "ca_key" {
  name   = "ca.key"
  content = tls_private_key.ca_key.private_key_pem
  bucket = google_storage_bucket.config_files.name
}

resource "google_storage_bucket_object" "server_cert" {
  name   = "server.crt"
  content = tls_locally_signed_cert.server_cert.cert_pem
  bucket = google_storage_bucket.config_files.name
}

resource "google_storage_bucket_object" "server_key" {
  name   = "server.key"
  content = tls_private_key.server_key.private_key_pem
  bucket = google_storage_bucket.config_files.name
}
