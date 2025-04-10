variable "keypair_name" {
  type = string
}

variable "router_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet_ipv4_name" {
  type = string
}

variable "subnet_ipv6_name" {
  type = string
}

variable "secgroup_name" {
  type = string
}

variable "instance_name" {
  type = string
}

variable external_network {
  type = string
  default = "ext-net"
}

variable ipv6_subnetpool {
  type = string
  default = "ipv6_tenant_pool"
}

variable ipv6_mode {
  type = string
  default = "slaac"

  validation {
    condition  = contains(["slaac", "dhcpv6-stateful", "dhcpv6-stateless"], var.ipv6_mode)
    error_message = "The ipv6_mode must be one of: slaac, dhcpv6-stateful, dhcpv6-stateless."
  }
}

variable "image" {
  type = string
  default = "Ubuntu 22.04 Jammy Jellyfish x86_64"
}

variable "flavor" {
  type = string
  default = "b.2c2gb"
}

variable "size" {
  type = string
  default = "20"
}

variable "region_left" {
  type = string
}

variable "region_right" {
  type = string
}

variable "psk" {
  type = string
}

variable "ike_policy_name" {
  type = string
}

variable "ipsec_policy_name" {
  type = string
}

variable "vpn_service_name" {
  type = string
}

variable "vpn_connection_name" {
  type = string
}

variable "epg_subnet_name" {
  type = string
}

variable "epg_cidr_name" {
  type = string
}
