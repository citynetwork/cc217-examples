resource "openstack_compute_keypair_v2" "keypair" {
  name = var.keypair_name
  public_key = "${file(pathexpand("~/.ssh/id_ed25519.pub"))}"
}

resource "openstack_networking_router_v2" "router" {
  name = var.router_name
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

resource "openstack_networking_network_v2" "network" {
  name = var.network_name
}

resource "openstack_networking_subnet_v2" "subnet" {
  name = var.subnet_name
  network_id = openstack_networking_network_v2.network.id
  cidr = "10.0.42.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8", "4.4.4.4"]
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_networking_floatingip_v2" "floatingip" {
  pool = var.external_network
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name = var.secgroup_name
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_compute_instance_v2" "instance" {
  name = var.instance_name
  flavor_name = var.flavor
  user_data = "${file("config.yaml")}"
  key_pair = openstack_compute_keypair_v2.keypair.name
  security_groups = [ openstack_networking_secgroup_v2.secgroup.id ]
  network {
    uuid = openstack_networking_network_v2.network.id
  }
  block_device  {
    uuid = data.openstack_images_image_v2.ubuntu_jammy.id
    source_type = "image"
    destination_type = "volume"
    boot_index = 0
    volume_size = var.size
    delete_on_termination = true
  }

}


resource "openstack_compute_floatingip_associate_v2" "floatingip" {
  floating_ip = "${openstack_networking_floatingip_v2.floatingip.address}"
  instance_id = "${openstack_compute_instance_v2.instance.id}"
  fixed_ip    = "${openstack_compute_instance_v2.instance.network.0.fixed_ip_v4}"
  depends_on  = [openstack_networking_router_interface_v2.router_interface]
}
