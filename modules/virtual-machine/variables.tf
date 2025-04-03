variable "datacenter" {
  description = "The name of the datacenter"
  type        = string
}

variable "datastore" {
  description = "The name of the datastore"
  type        = string
}

variable "vapp_id" {
  description = "The ID of the vApp to place the VM in"
  type        = string
}

variable "vm_name" {
  description = "The name of the VM"
  type        = string
}

variable "template" {
  description = "The VM template to clone from"
  type        = string
}

variable "num_cpus" {
  description = "Number of CPUs"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "networks" {
  description = "List of network configurations"
  type = list(object({
    name       = string
    ip_address = string
    netmask    = number
  }))
}

variable "gateway" {
  description = "Default gateway"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = []
}

variable "dns_suffix" {
  description = "List of DNS search domains"
  type        = list(string)
  default     = []
}

variable "domain" {
  description = "Domain name for the VM"
  type        = string
  default     = "local"
}

variable "disks" {
  description = "List of disk configurations"
  type = list(object({
    size             = number
    thin_provisioned = optional(bool, true)
    eagerly_scrub    = optional(bool, false)
  }))
}
