# create network
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

}

# create subnet
resource "aws_subnet" "subnet_1" {
  cidr_block        = cidrsubnet(aws_vpc.lab_vpc.cidr_block, 3, 1)
  vpc_id            = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_2" {
  cidr_block        = cidrsubnet(aws_vpc.lab_vpc.cidr_block, 3, 2)
  vpc_id            = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1a"
}

# create gateway
resource "aws_internet_gateway" "lab-env-gw" {
  vpc_id = aws_vpc.lab_vpc.id
}

# routing table for VPC ssh acces
resource "aws_route_table" "route-table-lab-env" {
  vpc_id = aws_vpc.lab_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-env-gw.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route-table-lab-env.id
  
}

resource "aws_route_table_association" "subnet-association2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route-table-lab-env.id
  
}