variable "security_group_name" {
  default = ""
}

variable "tcp_ports" {
  type = "string"
  default = "default_null"
}

variable "udp_ports" {
  default = "default_null"
}

variable "cidr" {
  type = "list"
}

variable "vpc_id" {}