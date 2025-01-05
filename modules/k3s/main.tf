resource "ssh_resource" "install_k3s" {
  for_each = local.servers
  host     = each.value.host
  user     = each.value.user
  port     = each.value.port
  private_key = file(each.value.private_key)

  when = "create"

  file {
    content = file("${path.module}/scripts/install_k3s.sh")
    destination = "/tmp/install_k3s.sh"
    permissions = "0700"
  }

  commands = [
    "/tmp/install_k3s.sh ${var.k3s.download_url} ${var.k3s.version}",
    //"rm -f /tmp/install_k3s.sh"

  ]

  timeout = "300s"
}

resource "ssh_resource" "start_k3s" {
  for_each = local.servers
  host     = each.value.host
  user     = each.value.user
  port     = each.value.port
  private_key = file(each.value.private_key)

  file {
    content = file("${path.module}/scripts/start_k3s.sh")
    destination = "/tmp/start_k3s.sh"
    permissions = "0700"
  }

  triggers = {
    always_run = timestamp()
  }
  commands = [
    "/tmp/start_k3s.sh",
    "rm -f /tmp/start_k3s.sh"
  ]


  timeout = "20s"
}

data "remote_file" "kubeconfig" {
  for_each = local.servers
  conn {
    host = each.value.host
    user = each.value.user
    private_key = file(each.value.private_key)
    port = each.value.port
  }
  path = "/etc/rancher/k3s/k3s.yaml"
  depends_on = [
    ssh_resource.start_k3s,
    ssh_resource.install_k3s,
  ]
}





