
locals {
  common_tags = concat(
    var.base_tags,
    var.additional_tags,
  )
  is_vm1 = contains(var.additional_tags, "name=vm1")
}

data "openstack_networking_network_v2" "main" {
  tags = var.base_tags
}

data "openstack_networking_subnet_v2" "main" {
  network_id = data.openstack_networking_network_v2.main.id
}

data "openstack_networking_secgroup_v2" "open" {
  tags = var.base_tags
}

resource "openstack_networking_port_v2" "main" {
  admin_state_up = true 
  network_id = data.openstack_networking_network_v2.main.id

  port_security_enabled = local.is_vm1 ? false : null # une politique interdit de modifier port_security_enabled (seul null est autorisé) si le port est créé dans un autre tenant que celui qui possède le subnet

  security_group_ids = local.is_vm1 ? null : [ # il est interdit de définir un security group (autre valeur que nulle) si port_security_enabled vaut false.
    data.openstack_networking_secgroup_v2.open.id,
  ]

  fixed_ip {
      subnet_id = data.openstack_networking_subnet_v2.main.id
      ip_address = var.ip_address
  }

  tags = local.common_tags
}

