variable "vapp_name" {
  description = "Name of the vApp container"
  type        = string
  default     = ""
}

variable "region_vapp_id" {
  description = "The ID of the parent vApp (leave empty for top-level vApp)"
  type        = string
  default     = ""
}

variable "datacenter" {
  description = "The name of the vSphere datacenter"
  type        = string
  default     = ""
}

variable "cluster" {
  description = "The name of the vSphere compute cluster"
  type        = string
  default     = ""
}
