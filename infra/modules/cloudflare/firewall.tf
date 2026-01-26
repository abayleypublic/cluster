resource "cloudflare_ruleset" "geo_blocking" {
  zone_id     = cloudflare_zone.austinbayley.id
  name        = "Geo-blocking for US and Europe"
  description = "Block traffic from countries outside US and Europe"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      expression  = "(ip.src.country eq \"RU\" or not ip.src.continent in {\"EU\" \"NA\"})"
      description = "Block access from non-US/Europe countries"
      enabled     = true
    }
  ]
}
