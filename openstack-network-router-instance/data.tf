data "openstack_networking_network_v2" "external_network" {
  name = var.external_network
}

data "openstack_images_image_v2" "ubuntu_jammy" {
  name = var.image
}

data "openstack_networking_subnetpool_v2" "ipv6_pool" {
  name = var.ipv6_subnetpool
}

