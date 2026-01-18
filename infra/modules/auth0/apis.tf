# ==========
# Staging
# =========

resource "auth0_resource_server" "staging_api" {
  name          = "Staging"
  identifier    = "https://stg.austinbayley.co.uk"
  signing_alg   = "RS256"
  token_dialect = "access_token"
}

resource "auth0_resource_server_scopes" "staging_scopes" {
  resource_server_identifier = auth0_resource_server.staging_api.identifier

  scopes {
    name        = "read:users"
    description = "Read user data"
  }
}

# ==========
# Production
# =========

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

# ==========
# Forms
# =========

resource "auth0_resource_server" "forms_api" {
  name          = "Forms"
  identifier    = "https://forms.austinbayley.co.uk"
  signing_alg   = "RS256"
  token_dialect = "access_token"
}

resource "auth0_resource_server_scopes" "forms_scopes" {
  resource_server_identifier = auth0_resource_server.forms_api.identifier

  scopes {
    name        = "read:users"
    description = "Read user data"
  }

  scopes {
    name        = "update:users"
    description = "Update user data"
  }

  scopes {
    name        = "create:users"
    description = "Create user data"
  }

  scopes {
    name        = "read:users_app_metadata"
    description = "Read user app metadata"
  }

  scopes {
    name        = "update:users_app_metadata"
    description = "Update user app metadata"
  }

  scopes {
    name        = "create:users_app_metadata"
    description = "Create user app metadata"
  }
}
