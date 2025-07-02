resource "auth0_resource_server" "production_api" {
  name          = "Production"
  identifier    = "https://austinbayley.co.uk"
  signing_alg   = "RS256"
  token_dialect = "access_token"
}

resource "auth0_resource_server_scopes" "production_scopes" {
  resource_server_identifier = auth0_resource_server.production_api.identifier

  scopes {
    name        = "read:users"
    description = "Read user data"
  }
}
