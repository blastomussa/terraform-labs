terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "lab_bucket" {
  bucket = "s3-website-lab.jcourtney"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lab_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "lab_website" {
  bucket = aws_s3_bucket.lab_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.lab_bucket.bucket
  key    = "index.html"
  content = templatefile("index.tpl", { gif_path = format("https://s3.amazonaws.com/%s/%s", aws_s3_bucket.lab_bucket.bucket, aws_s3_object.gif.key) })
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.lab_bucket.bucket
  key    = "404.html"
  source = "404.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "gif" {
  bucket = aws_s3_bucket.lab_bucket.bucket
  key = "github.gif"
  source = "github.gif"
  acl    = "public-read"
}


output "endpoint" {
  value = aws_s3_bucket_website_configuration.lab_website.website_endpoint
}

output "gif_url" {
  value = format("https://s3.amazonaws.com/%s/%s", aws_s3_bucket.lab_bucket.bucket, aws_s3_object.gif.key)
}