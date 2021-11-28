resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
