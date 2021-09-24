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
  default = "Ubuntu 20.04 Focal Fossa"
}

variable "flavor" {
  type = string
  default = "2C-2GB-20GB"
}

