# ==========
# Virtual Cloud Network
# ==========

resource "oci_core_vcn" "cluster_vcn" {
  compartment_id = oci_identity_compartment.cluster.id
  cidr_block     = "10.0.0.0/16"
  display_name   = "cluster_vcn"
  dns_label      = "clustervcn"
}

resource "oci_core_nat_gateway" "nat_gw" {
  compartment_id = oci_identity_compartment.cluster.id
  vcn_id         = oci_core_vcn.cluster_vcn.id
  display_name   = "nat_gateway"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = oci_identity_compartment.cluster.id
  vcn_id         = oci_core_vcn.cluster_vcn.id
  display_name   = "cluster_internet_gateway"
}

resource "oci_core_default_dhcp_options" "vcn_dhcp" {
  manage_default_resource_id = oci_core_vcn.cluster_vcn.default_dhcp_options_id

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
}

# ==========
# Public 
# ==========

resource "oci_core_route_table" "public_rt" {
  compartment_id = oci_identity_compartment.cluster.id
  vcn_id         = oci_core_vcn.cluster_vcn.id
  display_name   = "public_route_table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id             = oci_identity_compartment.cluster.id
  vcn_id                     = oci_core_vcn.cluster_vcn.id
  cidr_block                 = "10.0.128.0/24"
  display_name               = "public_subnet"
  dns_label                  = "publicsubnet"
  route_table_id             = oci_core_route_table.public_rt.id
  prohibit_public_ip_on_vnic = false
  security_list_ids          = [oci_core_security_list.public_sg.id]
}

resource "oci_core_security_list" "public_sg" {
  compartment_id = oci_identity_compartment.cluster.id
  vcn_id         = oci_core_vcn.cluster_vcn.id
  display_name   = "public_security_list"

  # TLS
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  # Kubernetes API server
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# ==========
# Private
# ==========

resource "oci_core_route_table" "private_rt" {
  compartment_id = oci_identity_compartment.cluster.id
  vcn_id         = oci_core_vcn.cluster_vcn.id
  display_name   = "private_route_table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gw.id
  }
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id             = oci_identity_compartment.cluster.id
  vcn_id                     = oci_core_vcn.cluster_vcn.id
  cidr_block                 = "10.0.0.0/17"
  display_name               = "private_subnet"
  dns_label                  = "privatesubnet"
  route_table_id             = oci_core_route_table.private_rt.id
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [oci_core_security_list.private_sg.id]
}

resource "oci_core_security_list" "private_sg" {
  compartment_id = oci_identity_compartment.cluster.id
  vcn_id         = oci_core_vcn.cluster_vcn.id
  display_name   = "private_cluster_security_list"

  # SSH
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Cilium Gateway 
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.128.0/24"
    tcp_options {
      min = 1024
      max = 1024
    }
  }

  # Cilium Health
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/17"
    tcp_options {
      min = 4240
      max = 4240
    }
  }

  # Cilium Hubble 
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/17"
    tcp_options {
      min = 4244
      max = 4245
    }
  }

  # Cilium Mutual Authentication
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/17"
    tcp_options {
      min = 4250
      max = 4250
    }
  }

  # Cilium Spire Agent health check 
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/17"
    tcp_options {
      min = 4251
      max = 4251
    }
  }

  # Cilium PPROF Servers
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/17"
    tcp_options {
      min = 6060
      max = 6062
    }
  }

  # Kubernetes API server
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/16"
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # VXLAN
  ingress_security_rules {
    protocol = "17" # UDP
    source   = "10.0.0.0/17"
    udp_options {
      min = 8472
      max = 8472
    }
  }

  # Cilium BPF Health Monitor
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/17"
    tcp_options {
      min = 9878
      max = 9879
    }
  }

  # Cilium GOPS Severs
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/17"
    tcp_options {
      min = 9890
      max = 9891
    }
  }

  # Cilium Hubble GOPS Severs
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/17"
    tcp_options {
      min = 9893
      max = 9893
    }
  }

  # Cilium Envoy Admin API 
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/17"
    tcp_options {
      min = 9901
      max = 9901
    }
  }

  # Cilium Prometheus metrics
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/17"
    tcp_options {
      min = 9962
      max = 9964
    }
  }

  # Metrics Server
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/16"
    tcp_options {
      min = 10250
      max = 10250
    }
  }

  # NodePort
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/17"
    tcp_options {
      min = 30000
      max = 32767
    }
  }

  # Cilium WireGuard encryption tunnel endpoint
  ingress_security_rules {
    protocol = "17" # UDP
    source   = "10.0.0.0/17"
    udp_options {
      min = 51871
      max = 51871
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# ==========
# Load Balancer
# ==========

resource "oci_load_balancer_load_balancer" "k3s_lb" {
  compartment_id = oci_identity_compartment.cluster.id
  display_name   = "k3s_public_lb"
  shape          = "flexible"
  subnet_ids     = [oci_core_subnet.public_subnet.id]
  is_private     = false
  # On the free tier, the load balancer is limited to 10 Mbps 
  # This may not apply to the flexible load balancer but better to be safe
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }
}

# HTTP Backend Set

resource "oci_load_balancer_backend_set" "k3s_https_backend_set" {
  name             = "k3s_https_backend_set"
  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = 1024
  }
}

resource "oci_load_balancer_backend" "k3s_https_backends" {
  for_each         = oci_core_instance.server
  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  backendset_name  = oci_load_balancer_backend_set.k3s_https_backend_set.name
  ip_address       = each.value.private_ip
  port             = 1024
}

resource "oci_load_balancer_listener" "k3s_https_listener" {
  name                     = "k3s_https_forward"
  load_balancer_id         = oci_load_balancer_load_balancer.k3s_lb.id
  default_backend_set_name = oci_load_balancer_backend_set.k3s_https_backend_set.name
  port                     = 443
  protocol                 = "TCP"
}

# API Backend Set

resource "oci_load_balancer_backend_set" "k3s_api_backend_set" {
  name             = "k3s_api_backend_set"
  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = 6443
  }
}

resource "oci_load_balancer_backend" "k3s_api_backends" {
  for_each = oci_core_instance.server

  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  backendset_name  = oci_load_balancer_backend_set.k3s_api_backend_set.name
  ip_address       = each.value.private_ip
  port             = 6443
}

resource "oci_load_balancer_listener" "k3s_api_listener" {
  name                     = "k3s_api_forward"
  load_balancer_id         = oci_load_balancer_load_balancer.k3s_lb.id
  default_backend_set_name = oci_load_balancer_backend_set.k3s_api_backend_set.name
  port                     = 6443
  protocol                 = "TCP"
}
