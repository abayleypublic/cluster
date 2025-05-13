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
  cidr_block                 = "10.0.1.0/24"
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

  # HTTP
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  # TLS
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
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
  cidr_block                 = "10.0.2.0/24"
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

  # Kubernetes API server
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/16"
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # NodePort
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "10.0.0.0/16"
    tcp_options {
      min = 30000
      max = 32767
    }
  }

  # VXLAN
  ingress_security_rules {
    protocol = "17" # UDP
    source   = "10.0.0.0/16"
    udp_options {
      min = 8472
      max = 8472
    }
  }

  # SSH
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
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

resource "oci_load_balancer_backend_set" "k3s_backend_set" {
  name             = "k3s_backend_set"
  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "TCP"
    port     = 30443
  }
}

resource "oci_load_balancer_backend" "k3s_backends" {
  for_each = oci_core_instance.server

  load_balancer_id = oci_load_balancer_load_balancer.k3s_lb.id
  backendset_name  = oci_load_balancer_backend_set.k3s_backend_set.name
  ip_address       = each.value.private_ip
  port             = 30443
}

resource "oci_load_balancer_listener" "k3s_tls_listener" {
  name                     = "k3s_https_forward"
  load_balancer_id         = oci_load_balancer_load_balancer.k3s_lb.id
  default_backend_set_name = oci_load_balancer_backend_set.k3s_backend_set.name
  port                     = 443
  protocol                 = "TCP"
}
