output "vapp_id" {
  description = "The ID of the created vApp"
  value       = vsphere_vapp_container.vapp_container.id
}
