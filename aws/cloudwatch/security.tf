# alow SSH and HTTP traffic
resource "aws_security_group" "main" {
  name   = "allow-all-sg"
  vpc_id = aws_vpc.lab_vpc.id

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
}


# registers ssh key with AWS
resource "aws_key_pair" "ssh_key" {
  key_name   = "lab-key"
  public_key = file("~/.ssh/id_rsa.pub") # use local machine's public rsa key
}

# create network
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

}

resource "aws_subnet" "subnet_1" {
  cidr_block        = cidrsubnet(aws_vpc.lab_vpc.cidr_block, 3, 1)
  vpc_id            = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1a"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

output "ami" {
  value = data.aws_ami.ubuntu.image_id
}

# AWS CLI EC2 Instance
# aws ec2 run-instances --image-id ami-072d6c9fae3253f26 \
# --count 1 --instance-type t2.micro \
# --key-name lab-key --security-group-ids sg-0c6f42767f556a064 --subnet-id subnet-0ffb1370ca1978048