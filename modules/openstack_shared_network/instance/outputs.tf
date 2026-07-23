output "ci_config" {
  value = data.cloudinit_config.main.rendered
}
