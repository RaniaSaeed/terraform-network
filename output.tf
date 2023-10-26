output "vpc_id" {
  value = aws_vpc.main.id
}
output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
}

output "route_table_pub_id" {
  value = aws_route_table.public
}

output "route_table_pri_id" {
  value = aws_route_table.private
}