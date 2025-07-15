resource "random_string" "public_tunnel_example_tunnel_secret" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

module "public_tunnel_example" {
  source = "./modules/simple_cloudflare_tunnel"

  account_id      = local.account_id
  zone_id         = local.sikademo4_uk_zone_id
  name            = "public-tunnel-example.sikademo4.uk"
  dns_record_name = "public-tunnel-example"
  tunnel_secret   = base64encode(random_string.public_tunnel_example_tunnel_secret.result)
  local_service   = "http://127.0.0.1:8000"
}

output "public_tunnel_example" {
  value     = module.public_tunnel_example
  sensitive = true
}
