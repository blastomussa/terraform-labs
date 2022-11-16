# Demo user
resource "aws_iam_user" "demo" {
  name = "demo"
  force_destroy = true
}

# demo user access key
resource "aws_iam_access_key" "key" {
  user = aws_iam_user.demo.name
}


# Policy Groups with full E3 Access and S3 Access
module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  for_each = {
    tech_support = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    design = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  }

  name = each.key

  group_users = [
    aws_iam_user.demo.name
  ]

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    each.value,
  ]
}