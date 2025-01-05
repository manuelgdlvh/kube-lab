terraform {
  required_version = ">=1.3.0"

  required_providers {

    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }

}