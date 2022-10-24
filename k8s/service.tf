# Kubernetes Service
resource "kubernetes_service" "api" {
  metadata {
    name      = "soap-recipe-api"
    namespace = "backend"
  }
  spec {
    selector = {
      App = kubernetes_deployment.api.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port = 80
    }

    type = "NodePort"
  }
}