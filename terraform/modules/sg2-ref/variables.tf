variable "security_group_name" {
  default = ""
}
variable "tcp_ports" {
  type = "string"
  default = "default_null"
}
variable "ref_security_groups_ids" {
  type =  "string"
  default = "self"
}
variable "vpc_id" {}