variable "keypair_name" {
  type = string
}
variable "image" {
  type = string
  default = "Fedora Atomic 29 [2019-08-20]"
}
variable "flavor" {
  type = string
  default = "2C-2GB-20GB"
}
variable "kubernetes_version" {
  type = string
  default = "1.15.7"
}
variable "template_name" {
  type = string
}
variable "cluster_name" {
  type = string
}

