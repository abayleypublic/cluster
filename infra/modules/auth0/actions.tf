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


resource "auth0_trigger_actions" "login_flow" {
  trigger = "post-login"

  actions {
    id           = auth0_action.add_permissions_to_id_token.id
    display_name = auth0_action.add_permissions_to_id_token.name
  }
}
