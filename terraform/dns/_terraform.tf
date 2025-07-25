terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.6.0"
    }
  }
}

variable "cloudflare_api_token" {}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  account_id           = "3d7bdb59b6b0972641e6dc9c2b2b9ade" // cloudflare-demo-1@ondrejsikamail.com account
  sikademo4_uk_zone_id = "014c02da23be8dfd741782892878296f" // sikademo4.uk zone
}
