locals {
  CLOUDFLARE_ACCESS_APPS_AND_POLICIES_WRITE_ACCOUNT = "1e13c5124ca64b72b1969a67e8829049"
  CLOUDFLARE_ACCESS_APPS_AND_POLICIES_WRITE_ZONE    = "959972745952452f8be2452be8cbb9f2"
}

resource "cloudflare_api_token" "for_access" {
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
      {
        id = local.CLOUDFLARE_ACCESS_APPS_AND_POLICIES_WRITE_ACCOUNT
      },
      {
        id = local.CLOUDFLARE_ACCESS_APPS_AND_POLICIES_WRITE_ZONE
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

output "cloudflare_api_token_for_access" {
  value     = cloudflare_api_token.for_access.value
  sensitive = true
}

output "curl_test_for_access" {
  value     = "curl -X GET \"https://api.cloudflare.com/client/v4/user/tokens/verify\"  -H \"Authorization: Bearer ${cloudflare_api_token.for_access.value}\"  -H \"Content-Type: application/json\""
  sensitive = true
}
