variable "keypair_name" {
  type = string
}
variable "image" {
  type = string
  default = "Fedora Atomic 29 "
}
variable "flavor" {
  type = string
  default = "2C-2GB-20GB"
}
variable "template_name" {
  type = string
}
variable "cluster_name" {
  type = string
}

