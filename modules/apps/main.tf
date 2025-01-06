resource "helm_release" "haproxy-ingress" {
  name        = "haproxy-ingress"
  chart       = "kubernetes-ingress"
  version     = "1.43.0"
  repository  = "https://haproxytech.github.io/helm-charts"
  description = "haproxy ingress allows accept incoming requests"

  values = [
    "${file("./values/haproxy-ingress.yaml")}"
  ]
  upgrade_install = true

}


resource "helm_release" "postgresql" {
  name        = "postgresql"
  chart       = "postgresql"
  repository  = "https://charts.bitnami.com/bitnami"
  version     = "16.0.0"
  description = "Postgresql database instance"
  values = [
    "${file("./values/postgresql.yaml")}"
  ]
  upgrade_install = true

}


resource "helm_release" "content_search_service" {
  name        = "content-search-service"
  chart       = "./charts/rust-service"
  version     = "1.0.0"
  description = "Content search service application"
  values = [
    "${file("./values/content-search-service.yaml")}"
  ]
  upgrade_install = true

}





