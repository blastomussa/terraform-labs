resource "mongodbatlas_project" "project" {
  name   = "test-proj1"
  org_id = var.org_id
}
output "project_name" {
  value = mongodbatlas_project.project.name
}