variable "auth_url" {
  type = string
  nullable = false
}

variable "username" {
  type = string
  nullable = false
}

variable "password" {
  type = string
  sensitive = true
  ephemeral = true
  nullable = false
}

variable "tenant1_id" {
  type = string
  nullable = false
}

variable "tenant2_id" {
  type = string
  nullable = false
}

variable "region" {
  type = string
  nullable = false
}

