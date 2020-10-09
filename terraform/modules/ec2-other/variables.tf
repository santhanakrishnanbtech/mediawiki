variable "instance_count" {
  default = "1"
}
variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "key_name" {}
variable "vpc_security_group_ids" {}
variable "associate_public_ip_address" {
  type        = bool
  default     = false
}
variable "private_ips" {}
variable "instance_name" {}