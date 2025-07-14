locals {
  DNS_WRITE = "4755a26eedb94da69e1066d98aa820be"
}

resource "cloudflare_api_token" "example_api_token" {
  name   = "example token"
  status = "active"
  policies = [{
    effect = "allow"
    permission_groups = [
      {
        id = local.DNS_WRITE
      }
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

output "cloudflare_api_token" {
  value     = cloudflare_api_token.example_api_token.value
  sensitive = true
}

output "curl_test" {
  value     = "curl -X GET \"https://api.cloudflare.com/client/v4/user/tokens/verify\"  -H \"Authorization: Bearer ${cloudflare_api_token.example_api_token.value}\"  -H \"Content-Type: application/json\""
  sensitive = true
}
