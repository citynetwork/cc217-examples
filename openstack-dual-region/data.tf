data "openstack_networking_network_v2" "external_network" {
  name = var.external_network
}

data "openstack_networking_network_v2" "external_network_right" {
  name = var.external_network
  provider = openstack.right
}
