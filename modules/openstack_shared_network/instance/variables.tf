variable "vcpu" {
  type = number
  default = 1
}

variable "ram" {
  type = number
  default = 1024
}

variable "disk" {
  type = number
  default = 10
}

variable "additional_addresses" {
  type = list(string)
  nullable = false
  default = []
}

variable "base_tags" {
  type = list(string)
  nullable = false
}

variable "additional_tags" {
  type = list(string)
  nullable = false
}
