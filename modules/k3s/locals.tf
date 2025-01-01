locals {
  servers = {for server in var.servers : server.host => server}
}
