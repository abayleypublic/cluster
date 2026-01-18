resource "auth0_client_credentials" "auth0_forms_client_credentials" {
  client_id = auth0_client.forms_client.client_id

  authentication_method = "client_secret_post"
}

resource "auth0_flow_vault_connection" "auth0_connection" {
  app_id       = "AUTH0"
  name         = "Auth0 M2M Connection"
  account_name = var.auth0_domain
  setup = {
    client_id     = auth0_client.forms_client.client_id
    client_secret = auth0_client_credentials.auth0_forms_client_credentials.client_secret
    domain        = var.auth0_domain
    type          = "OAUTH_APP"
    audience      = data.auth0_resource_server.management_api.identifier
  }
}

resource "auth0_flow" "update_user_details" {
  actions = jsonencode([{
    action        = "UPDATE_USER"
    alias         = "update user metadata"
    allow_failure = false
    id            = "update_user_details"
    mask_output   = false
    params = {
      changes = {
        name = "{{fields.full_name}}"
      }
      user_id       = "{{context.user.user_id}}"
      connection_id = auth0_flow_vault_connection.auth0_connection.id
    }
    type = "AUTH0"
  }])
  name = "Update User Details"
}

resource "auth0_form" "user_details" {
  name = "User Details Form"

  start = jsonencode({
    coordinates = {
      x = 0
      y = 0
    }
    next_node = "step_ggeX"
  })

  nodes = jsonencode([
    {
      alias = "New step"
      config = {
        components = [
          {
            category = "BLOCK"
            config = {
              content = "<h2>Personal Profile</h2><p>We require some data to complete your profile.</p>"
            }
            id   = "rich_text_uctu"
            type = "RICH_TEXT"
          },
          {
            category = "FIELD"
            config = {
              max_length = 50
              min_length = 1
              multiline  = false
            }
            id        = "full_name"
            label     = "Your Name"
            hint      = "<p>This should include your first and last names</p>"
            required  = true
            sensitive = false
            type      = "TEXT"
          },
          {
            category = "BLOCK"
            id       = "divider_D5WZ"
            type     = "DIVIDER"
          },
          {
            category = "BLOCK"
            config = {
              content = "<p>📝 Please verify your email address to avoid authentication errors</p>"
            }
            id   = "rich_text_NFeE"
            type = "RICH_TEXT"
          },
          {
            category = "BLOCK"
            config = {
              text = "Continue"
            }
            id   = "next_button_3FbA"
            type = "NEXT_BUTTON"
        }]
        next_node = "flow_Z4eS"
      }
      coordinates = {
        x = 500
        y = 0
      }
      id   = "step_ggeX"
      type = "STEP"
    },
    {
      config = {
        flow_id   = auth0_flow.update_user_details.id
        next_node = "$ending"
      }
      coordinates = {
        x = 1117
        y = 59
      }
      id   = "flow_Z4eS"
      type = "FLOW"
    },
  ])

  ending = jsonencode({
    after_submit = {
      flow_id = auth0_flow.update_user_details.id
    }
    coordinates = {
      x = 1531
      y = -40
    }
    resume_flow = true
  })

  style = jsonencode({
    css = "h1 {\n  color: white;\n  text-align: center;\n}"
  })

  messages {
    errors = jsonencode({
      ERR_REQUIRED_PROPERTY = "This field is required."
    })
  }

  languages {
    default = "en"
    primary = "en"
  }
}
