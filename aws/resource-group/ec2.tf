# data block to determine ami id
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

# registers ssh key with AWS
resource "aws_key_pair" "ssh_key" {
  key_name   = "lab-key"
  public_key = file("~/.ssh/id_rsa.pub") # use local machine's public rsa key
}

# elastic public IP address
resource "aws_eip" "ip-test-env" {
  instance = aws_instance.lab_ec2.id
  vpc      = true
}

resource "aws_eip" "ip-test-envb" {
  instance = aws_instance.lab_ec2b.id
  vpc      = true
}

# ubuntu instance
resource "aws_instance" "lab_ec2" {

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = aws_subnet.subnet_1.id

  user_data = filebase64("customdata.tpl")

  tags = {
    Env = "Prod"
  }
}


resource "aws_instance" "lab_ec2b" {

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = aws_subnet.subnet_2.id

  user_data = filebase64("customdata.tpl")

  tags = {
    Env = "Dev"
  }
}


