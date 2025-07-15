resource "cloudflare_dns_record" "hello" {
  zone_id = local.sikademo4_uk_zone_id
  name    = "hello.sikademo4.uk"
  type    = "TXT"
  content = "Hello world from DNS!"
  ttl     = 1
}
