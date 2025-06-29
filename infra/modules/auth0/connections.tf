resource "auth0_connection" "google_oauth2" {
  name     = "google-oauth2"
  strategy = "google-oauth2"

  options {
    scopes = ["email", "profile"]
  }
}

resource "auth0_connection" "production_db" {
  name                 = "production"
  is_domain_connection = false
  strategy             = "auth0"
  realms               = ["production"]
}
