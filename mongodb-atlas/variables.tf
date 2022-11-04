variable "mongo_user" {
  default = "jcourtney"
}

variable "mongodb_public_key" {
  description = "MongoDB Atlas Public Key"
}

variable "mongodb_private_key" {
  description = "MongoDB Atlas Private Key"
}

variable "org_id" {
  default = "63489715ce330e1a7cf318e4"
}


variable "cloud_provider" {
  type        = string
  description = "The cloud provider to use, must be AWS, GCP or AZURE"
  default     = "AWS"
}
variable "region" {
  type        = string
  description = "MongoDB Atlas Cluster Region, must be a region for the provider given"
  default     = "US_EAST_1"
}
variable "mongodbversion" {
  type        = string
  description = "The Major MongoDB Version"
  default     = "6.0"
}
variable "dbuser" {
  type        = string
  description = "MongoDB Atlas Database User Name"
  default     = "jcourtney"
}
variable "dbuser_password" {
  type        = string
  description = "MongoDB Atlas Database User Password"
}
variable "database_name" {
  type        = string
  description = "The database in the cluster to limit the database user to, the database does not have to exist yet"
  default     = "test-db"
}
variable "ip_address" {
  type        = string
  description = "The IP address that the cluster will be accessed from, can also be a CIDR range or AWS security group"
  default     = "75.131.74.138"
}

