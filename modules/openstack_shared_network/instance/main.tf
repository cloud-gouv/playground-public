data "openstack_compute_flavor_v2" "main" {
  vcpus = var.vcpu
  ram = var.ram
  disk = var.disk
}

data "openstack_images_image_v2" "main" {
  name = "ubuntu24.04"
  most_recent = true
}

data "openstack_networking_port_v2" "main" {
  tags = concat(
    var.base_tags,
    var.additional_tags,
  )
}

data "cloudinit_config" "main" {
  part {
    content_type = "text/cloud-config"
    content = <<EOT
#cloud-config
write_files:
  - path: /etc/netplan/config.yaml
    owner: "root:root"
    permissions: 0600
    content: |
      network:
        version: 2
        renderer: networkd
        ethernets:
          ens3:
            addresses:
%{for addr in data.openstack_networking_port_v2.main.all_fixed_ips~}
              - ${addr}/30
%{endfor~}
%{for addr in var.additional_addresses~}
              - ${addr}/30
%{endfor~}
runcmd:
  - systemctl stop NetworkManager
  - systemctl mask NetworkManager
  - netplan apply
  - systemctl restart systemd-networkd
EOT
  }
}

resource "random_pet" "main" {
  length = 2
  prefix = "openstack_shared_network-"
}

resource "openstack_compute_instance_v2" "main" {
  name = random_pet.main.id
  image_id = data.openstack_images_image_v2.main.id
  flavor_id = data.openstack_compute_flavor_v2.main.id
  power_state = "active"
  force_delete = true
  config_drive = true
  user_data = data.cloudinit_config.main.rendered

  network {
    port = data.openstack_networking_port_v2.main.id
  }
}

