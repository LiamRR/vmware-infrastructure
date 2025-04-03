data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "networks" {
  for_each      = { for idx, network in var.networks : idx => network.name }
  name          = each.value
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = var.vapp_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus  = var.num_cpus
  memory    = var.memory
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  # Network interfaces
  dynamic "network_interface" {
    for_each = var.networks
    content {
      network_id = data.vsphere_network.networks[network_interface.key].id
    }
  }

  # Disks
  dynamic "disk" {
    for_each = var.disks
    content {
      label            = "disk${disk.key}"
      size             = disk.value.size
      unit_number      = disk.key
      thin_provisioned = lookup(disk.value, "thin_provisioned", false)
      eagerly_scrub    = lookup(disk.value, "eagerly_scrub", false)
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.vm_name
        domain    = var.domain
      }

      dynamic "network_interface" {
        for_each = var.networks
        content {
          ipv4_address = network_interface.value.ip_address
          ipv4_netmask = network_interface.value.netmask
        }
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
      dns_suffix_list = var.dns_suffix
    }
  }
}
