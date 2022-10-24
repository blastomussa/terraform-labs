#resource "kubernetes_horizontal_pod_autoscaler_v1" "back" {
#  metadata {
#    name = "backend-api-scaler"
#  }
#
#  spec {
#    max_replicas = 6
#    min_replicas = 2
#    target_cpu_utilization_percentage = 25
#
#    scale_target_ref {
#      kind = "Deployment"
#      name = kubernetes_deployment.api.metadata[0].name
#    }
#  }
#}