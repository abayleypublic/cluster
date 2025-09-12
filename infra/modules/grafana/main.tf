terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.9.0"
    }
  }
}

resource "grafana_cloud_stack" "my_stack" {
  name        = "austinbayley.grafana.net"
  slug        = "austinbayley"
  region_slug = "prod-gb-south-1"
}

resource "grafana_cloud_stack_service_account" "cloud_sa" {
  stack_slug  = grafana_cloud_stack.my_stack.slug
  name        = "terraform"
  role        = "Editor"
  is_disabled = false
}

resource "grafana_cloud_stack_service_account_token" "cloud_sa" {
  stack_slug         = grafana_cloud_stack.my_stack.slug
  name               = "terraform serviceaccount key"
  service_account_id = grafana_cloud_stack_service_account.cloud_sa.id
}
