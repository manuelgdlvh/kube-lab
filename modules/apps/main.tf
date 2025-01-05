resource "helm_release" "haproxy-ingress" {
  name        = "haproxy-ingress"
  chart       = "kubernetes-ingress"
  version     = "1.43.0"
  repository  = "https://haproxytech.github.io/helm-charts"
  description = "haproxy ingress allows accept incoming requests"

  values = [
    "${file("./values/haproxy-ingress.yaml")}"
  ]
}


resource "helm_release" "example_app" {
  name        = "example-app"
  chart       = "./charts/microservices"
  version     = "1.0.0"
  description = "Example application"
  values = [
    "${file("./values/example-app.yaml")}"
  ]

}


