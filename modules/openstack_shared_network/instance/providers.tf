terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 3.0.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.9.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = ">= 2.4.0"
    }
  }
  required_version = ">= 1.11"
}
