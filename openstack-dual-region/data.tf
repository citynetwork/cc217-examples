data "openstack_networking_network_v2" "external_network" {
  name = var.external_network
}

data "openstack_networking_network_v2" "external_network_right" {
  name = var.external_network
  provider = openstack.right
}

data "openstack_images_image_v2" "ubuntu_jammy" {
  name = var.image
}

data "openstack_images_image_v2" "ubuntu_jammy_right" {
  name = var.image
  provider = openstack.right
}

