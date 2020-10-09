#--------------------------------------------------------------------[ VPC ]
resource "aws_vpc" "vpc" {
  cidr_block                  = var.vpc-cidr
  instance_tenancy            = var.instance-tenancy
  enable_dns_support          = var.enable-dns-support
  enable_dns_hostnames        = var.enable-dns-hostnames
  tags                        = {
    Name                      = "dev-mediawiki-vpc"
  }
}
#--------------------------------------------------------------------[ IGW ]
resource "aws_internet_gateway" "igw" {
  vpc_id                      = aws_vpc.vpc.id
  tags                        = {
    Name                      = "dev-mediawiki-igw"
  }
}
#--------------------------------------------------------------------[ EIP ]
resource "aws_eip" "eip-ngw" {
  vpc                         = true
  tags                        = {
    Name                      = "dev-mediawiki-eip"
  }
}
#--------------------------------------------------------------------[ NGW ]
resource "aws_nat_gateway" "ngw" {
  allocation_id               = aws_eip.eip-ngw.id
  subnet_id                   = aws_subnet.public-subnet.id
  tags                        = {
    Name                      = "dev-mediawiki-ngw"
  }
}

#--------------------------------------------------------------------[ SUBNET Public ]
resource "aws_subnet" "public-subnet" {
  availability_zone           = data.aws_availability_zones.available.names[0]
  cidr_block                  = var.vpc-public-subnet-cidr
  vpc_id                      = aws_vpc.vpc.id
  map_public_ip_on_launch     = var.map_public_ip_on_launch
  tags                        = {
    Name                      = "dev-mediawiki-subnet-public"
  }
}
resource "aws_route_table" "public-routes" {
  vpc_id                      = aws_vpc.vpc.id
  route {
    cidr_block                = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.igw.id
  }
  tags                        = {
    Name                      = "dev-mediawiki-public-rt"
  }
}
resource "aws_route_table_association" "public-association" {
  route_table_id              = aws_route_table.public-routes.id
  subnet_id                   = aws_subnet.public-subnet.id
}
#--------------------------------------------------------------------[ SUBNET Private ]
resource "aws_subnet" "private-subnet" {
  availability_zone           = data.aws_availability_zones.available.names[1]
  cidr_block                  = var.vpc-private-subnet-cidr
  vpc_id                      = aws_vpc.vpc.id
  tags                        = {
    Name                      = "dev-mediawiki-subnet-private"
  }
}
resource "aws_route_table" "private-routes" {
  vpc_id                      = aws_vpc.vpc.id
  route {
    cidr_block                = var.private-route-cidr
    nat_gateway_id            = aws_nat_gateway.ngw.id
  }
  tags                        = {
    Name                      = "dev-mediawiki-private-rt"
  }
}
resource "aws_route_table_association" "private-routes-linking" {
  subnet_id                   = aws_subnet.private-subnet.id
  route_table_id              = aws_route_table.private-routes.id
}
