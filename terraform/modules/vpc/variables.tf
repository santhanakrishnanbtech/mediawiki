variable "vpc-cidr" {
  default = ""
}
variable "instance-tenancy" {
  default = "default"
}
variable "enable-dns-support" {
  default = "true"
}
variable "enable-dns-hostnames" {
  default = "true"
}
data "aws_availability_zones" "available" {}
variable "vpc-public-subnet-cidr" {
  type = string
}
variable "map_public_ip_on_launch" {
  default = "true"
}
variable "vpc-private-subnet-cidr" {
  type = string
}
variable "private-route-cidr" {
  default = "0.0.0.0/0"
}

