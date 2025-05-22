resource "cloudflare_zone" "austinbayley" {
  name = "austinbayley.co.uk"
  type = "full"
  account = {
    id = "39006b4c125bbd02355ed1cd3a7bb22f"
  }
}
