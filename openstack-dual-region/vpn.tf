# "Left" region

resource "openstack_vpnaas_ike_policy_v2" "ike_policy_left" {
  name = "ike-policy"
}

resource "openstack_vpnaas_ipsec_policy_v2" "ipsec_policy_left" {
  name = "ipsec-policy"
}

resource "openstack_vpnaas_service_v2" "vpn_service_left" {
  name = "vpn-service"
  router_id = openstack_networking_router_v2.router.id
  admin_state_up = "true"
}

resource "openstack_vpnaas_endpoint_group_v2" "epg_subnet_left" {
  name = "epg-subnet-left"
  type = "subnet"
  endpoints = [openstack_networking_subnet_v2.subnet.id,]
}

resource "openstack_vpnaas_endpoint_group_v2" "epg_cidr_right" {
  name = "epg-cidr-right"
  type = "cidr"
  endpoints = [openstack_networking_subnet_v2.subnet_right.cidr,]
}

resource "openstack_vpnaas_site_connection_v2" "conn_left" {
  name = "vpn-connection"
  ikepolicy_id = openstack_vpnaas_ike_policy_v2.ike_policy_left.id
  ipsecpolicy_id = openstack_vpnaas_ipsec_policy_v2.ipsec_policy_left.id
  vpnservice_id = openstack_vpnaas_service_v2.vpn_service_left.id
  psk = var.psk
  peer_id = openstack_vpnaas_service_v2.vpn_service_right.external_v4_ip
  peer_address = openstack_vpnaas_service_v2.vpn_service_right.external_v4_ip
  local_ep_group_id = openstack_vpnaas_endpoint_group_v2.epg_subnet_left.id
  peer_ep_group_id  = openstack_vpnaas_endpoint_group_v2.epg_cidr_right.id
  depends_on  = [openstack_networking_router_interface_v2.router_interface]
}

# "Right" region

resource "openstack_vpnaas_ike_policy_v2" "ike_policy_right" {
  name = "ike_policy"
  provider = openstack.right
}

resource "openstack_vpnaas_ipsec_policy_v2" "ipsec_policy_right" {
  name = "ipsec-policy"
  provider = openstack.right
}

resource "openstack_vpnaas_service_v2" "vpn_service_right" {
  name = "vpn-service"
  router_id = openstack_networking_router_v2.router_right.id
  admin_state_up = "true"
  provider = openstack.right
}

resource "openstack_vpnaas_endpoint_group_v2" "epg_subnet_right" {
  name = "epg-subnet-right"
  type = "subnet"
  endpoints = [openstack_networking_subnet_v2.subnet_right.id,]
  provider = openstack.right
}

resource "openstack_vpnaas_endpoint_group_v2" "epg_cidr_left" {
  name = "epg-cidr-left"
  type = "cidr"
  endpoints = [openstack_networking_subnet_v2.subnet.cidr,]
  provider = openstack.right
}

resource "openstack_vpnaas_site_connection_v2" "conn_right" {
  name = "vpn-connection"
  ikepolicy_id = openstack_vpnaas_ike_policy_v2.ike_policy_right.id
  ipsecpolicy_id = openstack_vpnaas_ipsec_policy_v2.ipsec_policy_right.id
  vpnservice_id = openstack_vpnaas_service_v2.vpn_service_right.id
  psk = var.psk
  peer_id = openstack_vpnaas_service_v2.vpn_service_left.external_v4_ip
  peer_address = openstack_vpnaas_service_v2.vpn_service_left.external_v4_ip
  local_ep_group_id = openstack_vpnaas_endpoint_group_v2.epg_subnet_right.id
  peer_ep_group_id  = openstack_vpnaas_endpoint_group_v2.epg_cidr_left.id
  provider = openstack.right
  depends_on  = [openstack_networking_router_interface_v2.router_interface_right]
}
