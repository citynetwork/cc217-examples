resource "openstack_compute_keypair_v2" "keypair" {
  name = var.keypair_name
  public_key = "${file(pathexpand("~/.ssh/id_ed25519.pub"))}"
}
