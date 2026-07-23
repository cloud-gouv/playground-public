variable "ip_address" {
  type = string
}

variable "base_tags" {
  type = list(string)
  nullable = false
}

variable "additional_tags" {
  type = list(string)
  nullable = false
}
