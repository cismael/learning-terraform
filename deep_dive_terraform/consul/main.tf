##################################################################################
# CONFIGURATION - added for Terraform 0.14
##################################################################################

terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~>2.0"
    }
  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "consul" {
  address    = "127.0.0.1:8500"
  datacenter = "dc1"
}
