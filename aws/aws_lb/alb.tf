module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id          = aws_vpc.lab_vpc.id
  subnets         = [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id]
  security_groups = [aws_security_group.main.id]

  access_logs = {
    bucket = "my-alb-logs"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        my_target = {
          target_id = "i-0123456789abcdefg"  # add ec2 id
          port      = 80
        }
        my_other_target = {
          target_id = "i-a1b2c3d4e5f6g7h8i"  # add ec2 id
          port      = 80
        }
      }
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}