terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.25.0"
    }
  }
}

resource "auth0_prompt" "login_flow" {
  universal_login_experience     = "new"
  identifier_first               = true
  webauthn_platform_first_factor = false
}
