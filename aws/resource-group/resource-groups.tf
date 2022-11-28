resource "aws_resourcegroups_group" "rg1" {
  name = "prod-group"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Env",
      "Values": ["Prod"]
    }
  ]
}
JSON
  }
}

resource "aws_resourcegroups_group" "rg2" {
  name = "dev-group"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Env",
      "Values": ["Dev"]
    }
  ]
}
JSON
  }
}