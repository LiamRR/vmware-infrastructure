terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.11.1"
    }
  }
}

# vCenter Connection Details
# (Note: credentials should be provided via environment variables or other secure methods)
provider "vsphere" {
  user           = "user"
  password       = "password"
  vsphere_server = "server"
  allow_unverified_ssl = true 
}
