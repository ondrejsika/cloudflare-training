terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

variable "account_id" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "name" {
  type = string
}

variable "dns_record_name" {
  type = string
}

variable "tunnel_secret" {
  type = string
}

variable "local_service" {
  type = string
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id    = var.account_id
  name          = var.name
  config_src    = "cloudflare"
  tunnel_secret = var.tunnel_secret
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id
  config = {
    ingress = [
      {
        service = var.local_service
      }
    ]
    origin_request = {
      no_tls_verify = true
    }
  }
}

resource "cloudflare_dns_record" "this" {
  zone_id = var.zone_id
  name    = var.dns_record_name
  content = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

locals {
  token = base64encode(jsonencode({
    a = var.account_id
    t = cloudflare_zero_trust_tunnel_cloudflared.this.id
    s = var.tunnel_secret
  }))
}

output "tunnel_id" {
  value = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

output "token" {
  value     = local.token
  sensitive = true
}

output "cloudflared_run_command" {
  value     = "cloudflared --no-autoupdate tunnel run --token ${local.token}"
  sensitive = true
}

output "cloudflared_service_install_command" {
  value     = "cloudflared service install ${local.token}"
  sensitive = true
}
