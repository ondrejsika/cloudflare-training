resource "random_string" "access_tunnel_example_tunnel_secret" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

module "access_tunnel_example" {
  source = "./modules/simple_cloudflare_tunnel"

  account_id    = local.account_id
  zone_id       = local.sikademo4_uk_zone_id
  name          = "access-tunnel-example.sikademo4.uk"
  tunnel_secret = base64encode(random_string.access_tunnel_example_tunnel_secret.result)
  local_service = "http://127.0.0.1:8000"
}

output "access_tunnel_example" {
  value     = module.access_tunnel_example
  sensitive = true
}

module "access" {
  source = "./modules/simple_cloudflare_access"

  account_id = local.account_id
  zone_id    = local.sikademo4_uk_zone_id
  domain     = "access-tunnel-example.sikademo4.uk"
  access_email_domains = [
    "sika.io",
    "ondrejsika.com",
    "ondrejsikamail.com",
  ]
}
