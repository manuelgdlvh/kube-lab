resource "kubernetes_ingress_v1" "main_ingress" {
  metadata {
    name = "main-ingress"
    annotations = {
      "haproxy.org/rate-limit-requests" : "60",
      "haproxy.org/rate-limit-size" : "1000000",
      "haproxy.org/path-rewrite" : "/"
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
          path      = "/example"
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
          path      = "/metrics"
        }
      }
    }
  }
}

resource "kubernetes_network_policy" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = "default"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "name"
        operator = "In"
        values = ["postgresql-0"]
      }
    }

    ingress {
      ports {
        port     = "5432"
        protocol = "TCP"
      }
      from {
        namespace_selector {
          match_labels = {
            name = "default"
          }
        }
      }

      from {
        ip_block {
          cidr = "0.0.0.0/0"
          except = [
            "192.168.1.50/32",
            "192.168.1.111/32",
            "192.168.1.112/32"
          ]
        }
      }
    }

    egress {}
    policy_types = ["Ingress", "Egress"]
  }
}
