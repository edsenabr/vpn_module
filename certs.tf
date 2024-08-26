resource "null_resource" "generate_certs" {
  depends_on = [ 
    local_file.ca_cert, 
    local_file.client_cert, 
    local_file.client_key, 
  ]
}

# generate keys
resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
}

resource "tls_private_key" "server_key" {
  algorithm = "RSA"
}

resource "tls_private_key" "client_key" {
  algorithm = "RSA"
}

#generate CA
resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.ca_key.private_key_pem

  is_ca_certificate = true

  subject {
    common_name         = "ca.vpn.com"
  }

  validity_period_hours = 43800 //  1825 days or 5 years
  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

resource "tls_cert_request" "server_csr" {
  private_key_pem = tls_private_key.server_key.private_key_pem
  dns_names = ["server.vpn.com"]
  subject {
    common_name         = "server.vpn.com"
  }
}

resource "tls_cert_request" "client_csr" {
  private_key_pem = tls_private_key.client_key.private_key_pem
  dns_names = ["client.vpn.com"]
  subject {
    common_name         = "client.vpn.com"
  }
}

#generate certs
resource "tls_locally_signed_cert" "server_cert" {
  cert_request_pem = tls_cert_request.server_csr.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem
  validity_period_hours = 43800
  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}

resource "tls_locally_signed_cert" "client_cert" {
  cert_request_pem = tls_cert_request.client_csr.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem = tls_self_signed_cert.ca_cert.cert_pem
  validity_period_hours = 43800
  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}

resource "local_file" "client_key" {
  content  = tls_private_key.client_key.private_key_pem
  filename = "${path.root}/certs/client.key"
}

resource "local_file" "ca_cert" {
  content  = tls_self_signed_cert.ca_cert.cert_pem
  filename = "${path.root}/certs/ca.crt"
}

resource "local_file" "client_cert" {
  content  = tls_locally_signed_cert.client_cert.cert_pem
  filename = "${path.root}/certs/client.crt"
}