
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "nat_gtw_id" {
  value = aws_nat_gateway.natgtw.*.id
}

output "nat_gtw_ip" {
  value = aws_eip.natgtwip.*.public_ip
}

output "internet_gtw_id" {
  value = aws_internet_gateway.igw.*.id
}

output "web_private_subnet_ids" {
  value = aws_subnet.web_subnet_private.*.id
}

output "lb_public_subnet_ids" {
  value = aws_subnet.lb_subnet_public.*.id
}