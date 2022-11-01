output "subnet_cidr" {
  value = aws_subnet.subnet_1.cidr_block
}

output "url" {
  value = aws_eip.ip-test-env.public_dns
}

