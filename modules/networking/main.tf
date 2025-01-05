resource "kubernetes_ingress_v1" "main_ingress" {
  metadata {
    name = "main-ingress"
    annotations = {
      "haproxy.org/rate-limit-requests" : "60",
      "haproxy.org/rate-limit-size" : "1000000",
      "haproxy.org/path-rewrite": "/"
    }
  }

  spec {
    ingress_class_name = "haproxy"
    rule {
      http {
        path {
          backend {
            service {
              name = "example-app"
              port {
                number = 8080
              }
            }
          }
          path_type = "Prefix"
          path = "/example"
        }
      }
    }
    rule {
      http {
        path {
          backend {
            service {
              name = "metrics-server"
              port {
                number = 443
              }
            }
          }
          path_type = "Prefix"
          path = "/metrics"
        }
      }
    }
  }
}