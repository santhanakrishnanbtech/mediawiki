terraform {
  required_version = "~> 0.12.0"
}

provider "aws" {
  region = "ap-south-1"
  profile = "dev"
}

//resource "aws_default_vpc" "default" {
//  tags = {
//    Name = "Default VPC"
//  }
//}
#--------------------------------------------------------------------[ VPC ]
module "vpc" {
  source = "../../modules/vpc"
  map_public_ip_on_launch             = "true"
  vpc-cidr                            = "10.0.0.0/16"
  vpc-public-subnet-cidr              = "10.0.1.0/24"
  vpc-private-subnet-cidr             = "10.0.2.0/24"
}
#--------------------------------------------------------------------[ SG NO REF ]
module "ci_sg" {
  source                              = "../../modules/sg1"
  security_group_name        = "ci"
  tcp_ports                           = "22,80,81"
  cidr                                = ["0.0.0.0/0"]
  vpc_id                              = module.vpc.vpc-id
//  vpc_id                              = aws_default_vpc.default.id
}
#--------------------------------------------------------------------[ SG REF ]
module "web_sg" {
  source                      = "../../modules/sg2-ref"
  security_group_name        = "web"
  tcp_ports                   = "22,80"
  ref_security_groups_ids     = module.ci_sg.aws_security_group_default
    vpc_id                      = module.vpc.vpc-id
//  vpc_id                      = aws_default_vpc.default.id
}
#--------------------------------------------------------------------[ SG REF ]
module "db_sg" {
  source = "../../modules/sg3-db"
  security_group_name        = "db"
//  vpc_id                      = aws_default_vpc.default.id
  vpc_id                     =  module.vpc.vpc-id

  # Rule-1
  ingress-rule-1-from-port        = 22
  ingress-rule-1-to-port          = 22
  ingress-rule-1-protocol         = "tcp"
  ingress-rule-1-sg          = [module.ci_sg.aws_security_group_default]
  ingress-rule-1-description      = "Bastion Conn"

  # Rule-2
  ingress-rule-2-from-port          = 3306
  ingress-rule-2-to-port            = 3306
  ingress-rule-2-protocol           = "tcp"
  ingress-rule-2-security-groups    = [module.web_sg.aws_security_group_default]
  ingress-rule-2-description        = "Web Conn"

  # Rule-6
  ingress-rule-3-from-port        = -1
  ingress-rule-3-to-port          = -1
  ingress-rule-3-protocol         = "icmp"
  ingress-rule-3-cidrs  = ["0.0.0.0/0"]
  ingress-rule-3-description      = "Icmp Allowed"
}
#--------------------------------------------------------------------[ CONCOURSE/BASTION/NGINX ]
module "concourse" {
  source = "../../modules/ec2"
  instance_name = "dev-mediawiki-ci"
  ami = "ami-0e306788ff2473ccb"
  private_ips = "10.0.1.10"
  instance_count = "1"
  instance_type = "t2.micro"
  key_name = "PROD002"
//  subnet_id = "subnet-aa4749c2"
  subnet_id = module.vpc.public-subnet
  vpc_security_group_ids = [module.ci_sg.aws_security_group_default]
  associate_public_ip_address   = "true"
}
#--------------------------------------------------------------------[ WEB ]
module "web" {
  source = "../../modules/ec2-other"
  instance_name = "dev-mediawiki-web"
  ami = "ami-0e306788ff2473ccb"
  private_ips = "10.0.2.11"
  instance_count = "1"
  instance_type = "t2.micro"
  key_name = "PROD002"
//  subnet_id = "subnet-aa4749c2"
  subnet_id = module.vpc.private-subnet
  vpc_security_group_ids = [module.web_sg.aws_security_group_default]
  associate_public_ip_address   = "false"
}
#--------------------------------------------------------------------[ DB ]
module "db" {
  source = "../../modules/ec2-other"
  instance_name = "dev-mediawiki-db"
  ami = "ami-0e306788ff2473ccb"
  private_ips = "10.0.2.12"
  instance_count = "1"
  instance_type = "t2.micro"
  key_name = "PROD002"
//  subnet_id = "subnet-aa4749c2"
  subnet_id = module.vpc.private-subnet
  vpc_security_group_ids = [module.db_sg.aws_security_group]
  associate_public_ip_address   = "false"
}


