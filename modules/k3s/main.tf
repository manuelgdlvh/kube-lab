resource "ssh_resource" "install_k3s" {
  for_each = local.servers
  host     = each.value.host
  user     = each.value.user
  private_key = file(each.value.private_key)
  commands = [
    "if ! command -v k3s &>/dev/null; then",
    "  echo 'K3s is not installed, proceeding with installation...'",
    "  curl -sfL ${var.k3s.download_url} | INSTALL_K3S_VERSION='${var.k3s.version}' sh -s - server --docker --write-kubeconfig-mode 644 --disable=traefik",
    "else",
    "  echo 'K3s is already installed.'",
    "fi"
  ]
  timeout = "10m"
}


resource "ssh_resource" "start_k3s" {
  for_each = local.servers
  host     = each.value.host
  user     = each.value.user
  private_key = file(each.value.private_key)
  commands = [
    "if systemctl is-active --quiet k3s; then",
    "  echo 'K3s is installed and running, nothing to do.'",
    "else",
    "  echo 'K3s is installed but not running, starting the service...'",
    "  sudo systemctl start k3s",
    "fi"
  ]

  timeout = "10m"
}

data "remote_file" "kubeconfig" {
  for_each = local.servers
  conn {
    host = each.value.host
    user = each.value.user
    private_key = file(each.value.private_key)
  }
  path = "/etc/rancher/k3s/k3s.yaml"
  depends_on = [
    ssh_resource.start_k3s
  ]
}





