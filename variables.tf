###################
# vCenter Variables
###################
variable "datacenter" {
  type        = string
  default = ""
}
variable "cluster" {
  type        = string
  default = ""
}
variable "datastore" {
  type        = string
  default = ""
}

variable "resource_pool" {
  description = "vSphere resource pool"
  type        = string
  default     = ""
}

variable "template" {
  description = "The default VM template to clone from"
  type        = string
  default     = ""
}

################
# vApp Variables
################
variable "region_vapp" {
  description = "Name of the customer-specific vApp container"
  type        = string
  default     = ""
}

variable "datacenter_name" {
  description = "The name of the datacenter"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "The name of the compute cluster"
  type        = string
  default     = ""
}

variable "projects" {
  description = "Map of projects to create as child vApps"
  type = map(object({
    name = string
    vms = optional(map(object({
      name     = string
      num_cpus = optional(number)
      memory   = optional(number)
      networks = list(object({
        name       = string
        ip_address = string
        netmask    = number
      }))
      gateway     = string
      dns_servers = optional(list(string))
      dns_suffix = optional(list(string))
      domain      = optional(string)
      disks = list(object({
        size             = number
        thin_provisioned = optional(bool)
        eagerly_scrub    = optional(bool)
      }))
    })), {})
  }))
}
