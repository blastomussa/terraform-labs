# vpc + 2 subnets

# create network
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

}

# create subnet
resource "aws_subnet" "subnet" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.lab_vpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1a"
}