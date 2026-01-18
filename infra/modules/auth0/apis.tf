resource "auth0_resource_server" "austinbayley_co_uk_api" {
  name          = "austinbayley.co.uk"
  identifier    = "https://austinbayley.co.uk"
  signing_alg   = "RS256"
  token_dialect = "access_token"
}

resource "auth0_resource_server_scopes" "austinbayley_co_uk_scopes" {
  resource_server_identifier = auth0_resource_server.austinbayley_co_uk_api.identifier

  scopes {
    name        = "read:users"
    description = "Read user data"
  }
}

data "auth0_resource_server" "management_api" {
  identifier = "https://dev-hoo0x1gbvzrm2jd2.uk.auth0.com/api/v2/"
}
