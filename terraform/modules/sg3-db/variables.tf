variable "security_group_name" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

# Rule-1
variable "ingress-rule-1-from-port" {
  default = ""
}

variable "ingress-rule-1-to-port" {
  default = ""
}

variable "ingress-rule-1-protocol" {
  default = ""
}
variable "ingress-rule-1-sg" {
  default = ""
}
variable "ingress-rule-1-description" {
  default = ""
}

# Rule-2
variable "ingress-rule-2-from-port" {
  default = ""
}
variable "ingress-rule-2-to-port" {
  default = ""
}
variable "ingress-rule-2-protocol" {
  default = ""
}
variable "ingress-rule-2-security-groups" {}
variable "ingress-rule-2-description" {
  default = ""
}

# Rule-3
variable "ingress-rule-3-from-port" {
  default = ""
}
variable "ingress-rule-3-to-port" {
  default = ""
}
variable "ingress-rule-3-protocol" {
  default = ""
}
variable "ingress-rule-3-cidrs" {}
variable "ingress-rule-3-description" {
  default = ""
}