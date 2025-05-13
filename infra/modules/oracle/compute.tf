resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

resource "oci_core_instance" "server" {
  for_each = var.server_nodes

  availability_domain = each.value.availability_domain
  compartment_id      = oci_identity_compartment.cluster.id
  display_name        = each.key

  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 8
    ocpus         = 2
    vcpus         = 2
  }

  source_details {
    source_type = "image"
    source_id   = var.ampere_image_id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private_subnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")

    user_data = base64encode(templatefile("${path.module}/startup_scripts/server.tftpl", {
      lb_ip = oci_load_balancer_load_balancer.k3s_lb.ip_address_details[0].ip_address
      k3s_token = random_password.k3s_token.result
    }))
  }

  agent_config {
    is_monitoring_disabled = false
    is_management_disabled = false
    plugins_config {
      name          = "Bastion"
      desired_state = "ENABLED"
    }
    plugins_config {
      name          = "OS Management Service Agent"
      desired_state = "ENABLED"
    }
  }
}

resource "oci_core_instance" "ampere_agent" {
  for_each = var.ampere_agent_nodes

  availability_domain = each.value.availability_domain
  compartment_id      = oci_identity_compartment.cluster.id
  display_name        = each.key

  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 8
    ocpus         = 1
    vcpus         = 1
  }

  source_details {
    source_type = "image"
    source_id   = var.ampere_image_id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private_subnet.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")

    user_data = base64encode(templatefile("${path.module}/startup_scripts/agent.tftpl", {
      server_ip = oci_core_instance.server["server-1"].private_ip
      k3s_token = random_password.k3s_token.result
    }))
  }

  agent_config {
    is_monitoring_disabled = false
    is_management_disabled = false
    plugins_config {
      name          = "Bastion"
      desired_state = "ENABLED"
    }
    plugins_config {
      name          = "OS Management Service Agent"
      desired_state = "ENABLED"
    }
  }
}
