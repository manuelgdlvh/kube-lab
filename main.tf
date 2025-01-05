module "k3s" {
  source = "./modules/k3s"
  servers = [
    { "host" : "127.0.0.1", "user" : "root", "port" : 2222, "private_key" : "/home/manuelgdlvh/.ssh/id_rsa" }
  ]
}
module "apps" {
  source     = "modules/apps"
  kubeconfig = module.k3s.kubeconfig
}