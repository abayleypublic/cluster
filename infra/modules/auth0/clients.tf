resource "auth0_client" "oidc_client" {
  name                = "Production"
  description         = "Portfolio production OIDC client"
  app_type            = "regular_web"
  callbacks           = ["https://roam.austinbayley.co.uk/oauth2/callback"]
  allowed_logout_urls = ["https://*.austinbayley.co.uk"]
  web_origins         = ["https://*.austinbayley.co.uk"]
  oidc_conformant     = true

  jwt_configuration {
    alg = "RS256"
  }
}
