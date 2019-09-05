resource "openstack_compute_keypair_v2" "keypair" {
  name = var.keypair_name
  public_key = "${file(pathexpand("~/.ssh/id_rsa.pub"))}"
}

resource "openstack_containerinfra_clustertemplate_v1" "cluster-template" {
  name = var.template_name
  image = var.image
  coe = "kubernetes"
  flavor = var.flavor
  master_flavor = var.flavor
  dns_nameserver = "8.8.8.8"
  external_network_id = "ext-net"
  docker_storage_driver = "overlay"
  docker_volume_size = 5
  volume_driver = "cinder"
  network_driver = "flannel"
  floating_ip_enabled = true
  # master_lb_enabled must be true if master_count is > 1
  master_lb_enabled = false
  labels = {
    kube_tag = "v${var.kubernetes_version}"
  }
}

resource "openstack_containerinfra_cluster_v1" "cn-caas-cluster" {
 name = var.cluster_name
 cluster_template_id = openstack_containerinfra_clustertemplate_v1.cluster-template.id
 master_count = 1
 node_count = 1
 keypair = openstack_compute_keypair_v2.keypair.id
 create_timeout = 60
}
