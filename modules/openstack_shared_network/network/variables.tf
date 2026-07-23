variable "shared_tenant_id" {
  type = string
  nullable = false
}

variable "cidr" {
  type = string
}

variable "base_tags" {
  type = list(string)
}
