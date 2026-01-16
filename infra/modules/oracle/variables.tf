variable "compartment_id" {
  type = string
}

variable "server_nodes" {
  type = map(object({
    availability_domain = string
  }))

  default = {
    "server-1" = {
      availability_domain = "CzwP:UK-LONDON-1-AD-1"
    }
  }
}

variable "ampere_agent_nodes" {
  type = map(object({
    availability_domain = string
  }))

  default = {
    "agent-1" = {
      # It would appear that only availability domain 1 has the Ampere A1 compute shape available 
      availability_domain = "CzwP:UK-LONDON-1-AD-1"
    }
  }
}

variable "ampere_image_id" {
  type = string
  # Oracle-Linux-9.6-aarch64-2025.11.20-0
  default = "ocid1.image.oc1.uk-london-1.aaaaaaaayrzeqfjzgjbjaethpygka7teutvwxquyicyllui2m5yzbjxvpfja"
}
