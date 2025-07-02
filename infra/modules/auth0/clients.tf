resource "auth0_client" "production_client" {
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

resource "auth0_client_grant" "production_api_grant" {
  client_id = auth0_client.production_client.id
  audience  = auth0_resource_server.production_api.identifier
  scopes    = ["read:users"]
}
