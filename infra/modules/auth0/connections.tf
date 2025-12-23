# ==========
# Staging
# =========

resource "auth0_connection" "staging_db" {
  name                 = "staging"
  is_domain_connection = false
  strategy             = "auth0"
  realms               = ["staging"]

  options {
    password_policy        = "good"
    brute_force_protection = true
    strategy_version       = 2
    disable_signup         = true

    password_history {
      enable = true
      size   = 3
    }

    password_no_personal_info {
      enable = true
    }

    password_dictionary {
      enable     = true
      dictionary = ["password", "admin", "1234"]
    }

    password_complexity_options {
      min_length = 8
    }

    authentication_methods {
      passkey {
        enabled = true
      }
      password {
        enabled = true
      }
    }
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

  options {
    password_policy        = "good"
    brute_force_protection = true
    strategy_version       = 2
    disable_signup         = false

    password_history {
      enable = true
      size   = 3
    }

    password_no_personal_info {
      enable = true
    }

    password_dictionary {
      enable     = true
      dictionary = ["password", "admin", "1234"]
    }

    password_complexity_options {
      min_length = 8
    }

    authentication_methods {
      passkey {
        enabled = true
      }
      password {
        enabled = true
      }
    }
  }
}

resource "auth0_connection" "production_google_oauth2" {
  name     = "prd-google-oauth2"
  strategy = "google-oauth2"

  options {
    scopes = ["email", "profile"]
  }
}
