resource "cloudflare_dns_record" "hello" {
  zone_id = local.sikademo4_uk_zone_id
  name    = "hello"
  type    = "TXT"
  content = "Hello world from DNS!"
  ttl     = 0
}
