variable "keypair_name" {
  type = string
}

variable "router_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet_name" {
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
