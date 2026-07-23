terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "3.0.0"
    }
  }
  required_version = ">= 1.11"
}

provider "openstack" {
  alias = "tenant1"
  auth_url = var.auth_url
  user_name = var.username 
  password = var.password
  tenant_id = var.tenant1_id
  region = var.region
}

provider "openstack" {
  alias = "tenant2"
  auth_url = var.auth_url
  user_name = var.username 
  password = var.password
  tenant_id = var.tenant2_id
  region = var.region
}
