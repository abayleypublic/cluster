resource "auth0_action" "add_permissions_to_id_token" {
  name    = "add_permissions_to_id_token"
  runtime = "node18"
  deploy  = true

  code = <<-EOT
   exports.onExecutePostLogin = async (event, api) => {
     const roles = (event.authorization || {}).roles || [];
     api.idToken.setCustomClaim('https://austinbayley.co.uk/groups', roles);
   };
  EOT

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }
}

resource "auth0_action" "ensure_verified" {
  name    = "ensure_verified"
  runtime = "node18"
  deploy  = true

  code = <<-EOT
   exports.onExecutePostLogin = async (event, api) => {
     console.log('email verified status:', event.user.email_verified);
     console.log('connection:', event.connection.name);
     console.log('strategy:', event.connection.strategy);
     
     // Only enforce email verification for database connections (auth0 strategy)
     // Social providers (google-oauth2, etc.) handle email verification themselves
     if (event.connection.strategy === 'auth0' && !event.user.email_verified) {
       api.access.deny('Please verify your email before logging in.');
     }
   };
  EOT

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }
}


resource "auth0_trigger_actions" "login_flow" {
  trigger = "post-login"

  actions {
    id           = auth0_action.ensure_verified.id
    display_name = auth0_action.ensure_verified.name
  }

  actions {
    id           = auth0_action.add_permissions_to_id_token.id
    display_name = auth0_action.add_permissions_to_id_token.name
  }
}
