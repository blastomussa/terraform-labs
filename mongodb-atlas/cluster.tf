resource "mongodbatlas_cluster" "cluster" {
  project_id             = mongodbatlas_project.project.id
  name                   = "test-cluster1"
  mongo_db_major_version = var.mongodbversion
  cluster_type           = "REPLICASET"

  # provider
  provider_name               = "TENANT"
  backing_provider_name       = var.cloud_provider
  provider_region_name        = var.region

  # size; free tier requires TENANT provider
  provider_instance_size_name = "M0"
}
output "connection_strings" {
  value = mongodbatlas_cluster.cluster.connection_strings
}

