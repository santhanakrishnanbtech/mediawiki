output "vpc-id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}
output "igw" {
  value = aws_internet_gateway.igw.id
}
output "public-subnet" {
  description = "Public Subnets IDS"
  value       = aws_subnet.public-subnet.id
}
output "eip-ngw" {
  value = aws_eip.eip-ngw.id
}
output "ngw" {
  value = aws_nat_gateway.ngw.id
}
output "private-subnet" {
  description = "Private Subnets IDS"
  value       = aws_subnet.private-subnet.id
}
output "public-association" {
  value = aws_route_table_association.public-association.id
}
output "aws-route-table-public-routes-id" {
  value = aws_route_table.public-routes.id
}
output "aws-route-table-private-routes-id" {
  value = aws_route_table.private-routes.id
}
//output "aws-availability-zones" {
//  value = aws_availability_zones.azs.id
//}
