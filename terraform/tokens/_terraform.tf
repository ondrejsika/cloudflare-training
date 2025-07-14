terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.6.0"
    }
  }
}

variable "cloudflare_email" {}
variable "cloudflare_api_key" {}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

locals {
  account_id           = "3d7bdb59b6b0972641e6dc9c2b2b9ade" // cloudflare-demo-1@ondrejsikamail.com account
  sikademo1_uk_zone_id = "3ba5d048f4d88833ae1e2638ad57ee64" // sikademo1.uk zone
  sikademo2_uk_zone_id = "dd0036cc8abdf8d12eb9a8cc150d9f08" // sikademo2.uk zone
  sikademo3_uk_zone_id = "db23d39fbe9feaf207f0007680022fbc" // sikademo3.uk zone
  sikademo4_uk_zone_id = "014c02da23be8dfd741782892878296f" // sikademo4.uk zone
}
