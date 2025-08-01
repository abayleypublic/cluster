resource "cloudflare_dns_record" "root" {
  zone_id  = cloudflare_zone.austinbayley.id
  comment  = "Root DNS record for austinbayley.co.uk"
  content  = var.public_ip
  name     = "austinbayley.co.uk"
  proxied  = true
  ttl      = 1
  type     = "A"
  settings = {}
}

resource "cloudflare_dns_record" "wildcard" {
  zone_id  = cloudflare_zone.austinbayley.id
  comment  = "Wildcard DNS record for austinbayley.co.uk"
  content  = var.public_ip
  name     = "*.austinbayley.co.uk"
  proxied  = true
  ttl      = 1
  type     = "A"
  settings = {}
}

resource "cloudflare_dns_record" "wildcard_stg" {
  zone_id  = cloudflare_zone.austinbayley.id
  comment  = "Wildcard DNS record for staging environment on austinbayley.co.uk"
  content  = var.public_ip
  name     = "*.stg.austinbayley.co.uk"
  proxied  = false
  ttl      = 1
  type     = "A"
  settings = {}
}

resource "cloudflare_dns_record" "kube" {
  zone_id  = cloudflare_zone.austinbayley.id
  comment  = "Kubernetes DNS record for austinbayley.co.uk"
  content  = var.public_ip
  name     = "kube.austinbayley.co.uk"
  proxied  = false
  ttl      = 1
  type     = "A"
  settings = {}
}
