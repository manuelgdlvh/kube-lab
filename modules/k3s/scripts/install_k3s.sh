k3s_download_url=$1
k3s_version=$2

echo 'K3s is not installed, proceeding with installation...'
curl -sfL ${k3s_download_url} | INSTALL_K3S_VERSION=${k3s_version} sh -s - server --docker --write-kubeconfig-mode 644 --disable=traefik
