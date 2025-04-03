# Create a top-level regional vApp
module "region_vapp" {
  source = "./modules/vapp"

  datacenter = var.datacenter
  cluster    = var.cluster
  vapp_name  = var.region_vapp
}

# Create project specific vApps that will be part of the regional vApp
module "project_vapps" {
  source   = "./modules/vapp"
  for_each = var.projects

  datacenter     = var.datacenter
  cluster        = var.cluster
  vapp_name      = each.value.name
  region_vapp_id = module.region_vapp.vapp_id
}

# Create VMs for each project
module "vms" {
  source = "./modules/virtual-machine"

  # This creates a map with keys like "proj_mdr.mdr_*" for each VM
  for_each = {
    for vm_key in flatten([
      for proj_key, proj in var.projects : [
        for vm_key, vm in lookup(proj, "vms", {}) : {
          id          = "${proj_key}.${vm_key}"
          project_key = proj_key
          vm_key      = vm_key
          vm          = vm
        }
      ]
    ]) : vm_key.id => vm_key
  }

  datacenter = var.datacenter
  datastore  = var.datastore
  template   = var.template
  vapp_id    = module.project_vapps[each.value.project_key].vapp_id

  vm_name     = each.value.vm.name
  num_cpus    = lookup(each.value.vm, "num_cpus", 2)
  memory      = lookup(each.value.vm, "memory", 4096)
  networks    = each.value.vm.networks
  gateway     = each.value.vm.gateway
  dns_servers = lookup(each.value.vm, "dns_servers", [])
  dns_suffix  = lookup(each.value.vm, "dns_suffix", [])
  domain      = lookup(each.value.vm, "domain", "local")
  disks       = each.value.vm.disks
}
