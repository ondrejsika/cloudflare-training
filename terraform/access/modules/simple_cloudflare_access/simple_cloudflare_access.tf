// https://github.com/cloudflare/terraform-provider-cloudflare/issues/5731
// https://github.com/cloudflare/terraform-provider-cloudflare/issues/5495

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

variable "account_id" {}
variable "zone_id" {}
variable "domain" {}
variable "access_email_domains" {}


resource "cloudflare_zero_trust_access_application" "this" {
  lifecycle {
    ignore_changes = [
      policies[0].id,
    ]
  }

  zone_id          = var.zone_id
  name             = var.domain
  domain           = var.domain
  type             = "self_hosted"
  session_duration = "999h"
  destinations = [
    {
      type = "public"
      uri  = var.domain
    },
  ]
  policies = [
    {
      name       = "${var.domain} allow"
      decision   = "allow"
      precedence = 1
      include = [
        for domain in var.access_email_domains :
        {
          email_domain = {
            domain = domain
          }
        }
      ]
      exclude          = []
      require          = []
      session_duration = "999h"
    }
  ]
}
