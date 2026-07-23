locals {
  common_tags = [
    "removeme=true",
    "playground=openstack_shared_network",
    "resource_owner=Florian Alyx Maury",
  ]
}


module "network" {
  source = "../modules/openstack_shared_network/network"
  
  providers = {
    openstack = openstack.tenant1
  }
  
  shared_tenant_id = var.tenant2_id
  cidr = "172.16.108.0/30"

  base_tags = local.common_tags
}

module "tenant1_port" {
  depends_on = [ module.network ]

  source = "../modules/openstack_shared_network/port"

  providers = {
    openstack = openstack.tenant1
  }

  ip_address = "172.16.108.1"
  base_tags = local.common_tags
  additional_tags = [
    "name=vm1",
  ]
}

module "tenant2_port" {
  depends_on = [ module.network ]

  source = "../modules/openstack_shared_network/port"

  providers = {
    openstack = openstack.tenant2
  }

  ip_address = null # définir cette adresse IP cause une violation de politique de sécurité ; l'allocation DOIT etre dynamique si le port est créé sur un shared network et dans un tenant de destination du partage

  base_tags = local.common_tags
  additional_tags = [
    "name=vm2",
  ]
}

module "vm1" {
  depends_on = [ module.tenant1_port ]
  
  source = "../modules/openstack_shared_network/instance"

  providers = {
    openstack = openstack.tenant1
  }

  additional_addresses = [
    "172.17.0.1",
  ]

  base_tags = local.common_tags
  additional_tags = [
    "name=vm1",
  ]
}

module "vm2" {
  depends_on = [ module.tenant2_port ]
  
  source = "../modules/openstack_shared_network/instance"

  providers = {
    openstack = openstack.tenant2
  }

  additional_addresses = [
    "172.17.0.2",
  ]

  base_tags = local.common_tags
  additional_tags = [
    "name=vm2",
  ]
}
