# Load read only values from the vSphere provider
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Create the vApp container
resource "vsphere_vapp_container" "vapp_container" {
  name                    = var.vapp_name
  parent_resource_pool_id = var.region_vapp_id != "" ? var.region_vapp_id : data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  
  lifecycle {
    ignore_changes = [parent_folder_id]
  }
}
