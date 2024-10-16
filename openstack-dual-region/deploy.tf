# "Left" region

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
  image_name = var.image
  flavor_name = var.flavor
  user_data = "${file("config.yaml")}"
  key_pair = openstack_compute_keypair_v2.keypair.name
  security_groups = [ openstack_networking_secgroup_v2.secgroup.id ]
  network {
    uuid = openstack_networking_network_v2.network.id
  }
}

resource "openstack_compute_floatingip_associate_v2" "floatingip" {
  floating_ip = "${openstack_networking_floatingip_v2.floatingip.address}"
  instance_id = "${openstack_compute_instance_v2.instance.id}"
  fixed_ip    = "${openstack_compute_instance_v2.instance.network.0.fixed_ip_v4}"
  depends_on  = [openstack_networking_router_interface_v2.router_interface]
}


# "Right" region

resource "openstack_compute_keypair_v2" "keypair_right" {
  name = var.keypair_name
  public_key = "${file(pathexpand("~/.ssh/id_ed25519.pub"))}"
  provider = openstack.right
}

resource "openstack_networking_router_v2" "router_right" {
  name = var.router_name
  external_network_id = data.openstack_networking_network_v2.external_network_right.id
  provider = openstack.right
}

resource "openstack_networking_network_v2" "network_right" {
  name = var.network_name
  provider = openstack.right
}

resource "openstack_networking_subnet_v2" "subnet_right" {
  name = var.subnet_name
  network_id = openstack_networking_network_v2.network_right.id
  cidr = "10.1.49.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8", "4.4.4.4"]
  provider = openstack.right
}

resource "openstack_networking_router_interface_v2" "router_interface_right" {
  router_id = openstack_networking_router_v2.router_right.id
  subnet_id = openstack_networking_subnet_v2.subnet_right.id
  provider = openstack.right
}

resource "openstack_networking_floatingip_v2" "floatingip_right" {
  pool = var.external_network
  provider = openstack.right
}

resource "openstack_networking_secgroup_v2" "secgroup_right" {
  name = var.secgroup_name
  provider = openstack.right
}

resource "openstack_networking_secgroup_rule_v2" "ssh_right" {
  security_group_id = openstack_networking_secgroup_v2.secgroup_right.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0"
  provider = openstack.right
}

resource "openstack_networking_secgroup_rule_v2" "icmp_right" {
  security_group_id = openstack_networking_secgroup_v2.secgroup_right.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "0.0.0.0/0"
  provider = openstack.right
}

resource "openstack_compute_instance_v2" "instance_right" {
  name = var.instance_name
  image_name = var.image
  flavor_name = var.flavor
  user_data = "${file("config.yaml")}"
  key_pair = openstack_compute_keypair_v2.keypair_right.name
  security_groups = [ openstack_networking_secgroup_v2.secgroup_right.id ]
  network {
    uuid = openstack_networking_network_v2.network_right.id
  }
  provider = openstack.right
}

resource "openstack_compute_floatingip_associate_v2" "floatingip_right" {
  floating_ip = "${openstack_networking_floatingip_v2.floatingip_right.address}"
  instance_id = "${openstack_compute_instance_v2.instance_right.id}"
  fixed_ip    = "${openstack_compute_instance_v2.instance_right.network.0.fixed_ip_v4}"
  depends_on  = [openstack_networking_router_interface_v2.router_interface_right]
  provider = openstack.right
}
