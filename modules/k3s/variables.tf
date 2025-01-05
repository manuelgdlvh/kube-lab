variable "k3s" {
  type = object({
    download_url = string,
    version      = string,
  })
  description = "K3s instance details"
  default = {
    download_url = "https://get.k3s.io",
    version      = "v1.25.5+k3s1"
  }
  validation {
    condition = can(regex("^https?://[a-zA-Z0-9.-]+(?:/[a-zA-Z0-9/-]*)?$", var.k3s.download_url))
    error_message = "The provided URL is not valid. It should start with http:// or https:// and be a valid URL format."
  }

}

variable "servers" {
  type = list(object({
    host        = string
    user        = string
    port        = number
    private_key = string
  }))
  default = []
  description = "Node IPs"
  validation {
    condition = alltrue([
      for server in var.servers :
      can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", server.host))
    ])
    error_message = "One of the IPs provided are invalid"
  }
}

