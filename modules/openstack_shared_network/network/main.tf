resource "openstack_networking_network_v2" "main" {
  admin_state_up = true
  tags = var.base_tags
}

resource "openstack_networking_rbac_policy_v2" "shared_network" {
  action = "access_as_shared"
  object_id = openstack_networking_network_v2.main.id
  object_type = "network"
  target_tenant = var.shared_tenant_id
}

resource "openstack_networking_subnet_v2" "main" {
  network_id = openstack_networking_network_v2.main.id
  cidr = var.cidr
  enable_dhcp = false
  no_gateway = true
}

resource "random_pet" "secgroup" {
  length = 2
  prefix = "sec"
}

resource "openstack_networking_secgroup_v2" "open" {
  name = random_pet.secgroup.id
  tags = var.base_tags
}

resource "openstack_networking_rbac_policy_v2" "shared_secgroup" {
  action = "access_as_shared"
  object_id = openstack_networking_secgroup_v2.open.id
  object_type = "security_group"
  target_tenant = var.shared_tenant_id
}

resource "openstack_networking_secgroup_rule_v2" "ingress" {
  direction = "ingress"
  ethertype = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.open.id
  remote_group_id = openstack_networking_secgroup_v2.open.id
}

resource "openstack_networking_secgroup_rule_v2" "egress" {
  direction = "egress"
  ethertype = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.open.id
  remote_group_id = openstack_networking_secgroup_v2.open.id
}
