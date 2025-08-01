# ==========
# Staging
# =========

resource "auth0_connection" "staging_db" {
  name                 = "staging"
  is_domain_connection = false
  strategy             = "auth0"
  realms               = ["staging"]
}

resource "auth0_connection" "staging_google_oauth2" {
  name     = "stg-google-oauth2"
  strategy = "google-oauth2"

  options {
    scopes = ["email", "profile"]
  }
}


# ==========
# Production
# =========

resource "auth0_connection" "production_db" {
  name                 = "production"
  is_domain_connection = false
  strategy             = "auth0"
  realms               = ["production"]
}

resource "auth0_connection" "production_google_oauth2" {
  name     = "prd-google-oauth2"
  strategy = "google-oauth2"

  options {
    scopes = ["email", "profile"]
  }
}
