# ==========
# Staging
# =========

resource "auth0_client" "staging_client" {
  name                = "Staging"
  description         = "Portfolio staging OIDC client"
  app_type            = "regular_web"
  callbacks           = ["https://activity.stg.austinbayley.co.uk/oauth2/callback"]
  allowed_logout_urls = ["https://*.stg.austinbayley.co.uk"]
  web_origins         = ["https://*.stg.austinbayley.co.uk"]
  oidc_conformant     = true

  jwt_configuration {
    alg = "RS256"
  }
}

resource "auth0_client_grant" "staging_api_grant" {
  client_id = auth0_client.staging_client.id
  audience  = auth0_resource_server.staging_api.identifier
  scopes    = ["read:users"]
}

resource "auth0_connection_clients" "staging_db_clients" {
  connection_id = auth0_connection.staging_db.id
  enabled_clients = [
    auth0_client.staging_client.id,
  ]
}

# ==========
# Production
# =========

resource "auth0_client" "production_client" {
  name                = "Production"
  description         = "Portfolio production OIDC client"
  app_type            = "regular_web"
  callbacks           = ["https://activity.austinbayley.co.uk/oauth2/callback"]
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

resource "auth0_connection_clients" "production_db_clients" {
  connection_id = auth0_connection.production_db.id
  enabled_clients = [
    auth0_client.production_client.id,
  ]
}

resource "auth0_connection_clients" "production_google_clients" {
  connection_id = auth0_connection.production_google_oauth2.id
  enabled_clients = [
    auth0_client.production_client.id,
  ]
}
