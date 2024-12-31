output "vm_list" {
  value = flatten([
    for host in proxmox_virtual_environment_vm.ubuntu_vm : {
      "name" : host.name,
      "ipv4" : flatten(host.ipv4_addresses)
      #"mac" : flatten(host.mac_addresses)
      #"memory" : flatten(host.memory)
      #"cpu" : flatten(host.cpu)
    }
  ])
}
