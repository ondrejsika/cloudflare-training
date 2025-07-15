locals {
  CLOUDFLARE_TUNNEL_WRITE = "c07321b023e944ff818fec44d8203567"
}

resource "cloudflare_api_token" "for_tunnels" {
  name   = "example token for tunnels"
  status = "active"
  policies = [{
    effect = "allow"
    permission_groups = [
      {
        id = local.CLOUDFLARE_TUNNEL_WRITE
      },
      {
        id = local.DNS_WRITE
      },
    ]
    resources = {
      "com.cloudflare.api.account.${local.account_id}"                = "*"
      "com.cloudflare.api.account.zone.${local.sikademo1_uk_zone_id}" = "*"
      "com.cloudflare.api.account.zone.${local.sikademo2_uk_zone_id}" = "*"
      "com.cloudflare.api.account.zone.${local.sikademo3_uk_zone_id}" = "*"
      "com.cloudflare.api.account.zone.${local.sikademo4_uk_zone_id}" = "*"
    }
  }]
}

output "cloudflare_api_token_for_tunnels" {
  value     = cloudflare_api_token.for_tunnels.value
  sensitive = true
}

output "curl_test_for_tunnels" {
  value     = "curl -X GET \"https://api.cloudflare.com/client/v4/user/tokens/verify\"  -H \"Authorization: Bearer ${cloudflare_api_token.for_tunnels.value}\"  -H \"Content-Type: application/json\""
  sensitive = true
}
