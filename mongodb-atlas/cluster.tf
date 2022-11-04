resource "mongodbatlas_cluster" "cluster" {
  project_id             = mongodbatlas_project.project.id
  name                   = "test-cluster1"
  mongo_db_major_version = var.mongodbversion
  cluster_type           = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = var.region
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  # Provider Settings "block"
  cloud_backup                 = false
  auto_scaling_disk_gb_enabled = false
  provider_name                = var.cloud_provider
  provider_instance_size_name  = "M0"
}
output "connection_strings" {
  value = mongodbatlas_cluster.cluster.connection_strings
}

