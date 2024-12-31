module "bastion_node" {
  source                 = "./modules/ubuntu-vm-module"
  node_count             = 1
  vm_name_prefix         = var.use_legacy_naming_convention ? "${var.env_name}-k8s-bnode" : "vm-${local.cluster_name}-bnode"
  vm_id                  = 400
  pm_host                = var.pm_host
  vm_image_id            = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
  vm_cloud_init_file_id  = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  vm_vcpus               = 4
  vm_memory_mb           = 2048
  vm_boot_disk_interface = "virtio0"
  vm_boot_disk_size_gb   = 100
  vm_boot_storage_id     = var.vm_boot_storage_id
  vm_startup_order       = 1
  vm_username            = var.vm_username
  vm_password            = var.vm_password
  vm_ssh_public_key_path = var.vm_ssh_public_key_path
  vm_tags                = "${var.env_name};terraform;bastion_node;ramakrishna"
  vm_ip_config = [
    { vm_network_bridge_name = "vmbr0", vm_subnet_cidr = "192.168.20.0/24", vm_host_number = 30 },
    { vm_network_bridge_name = "vmbr1", vm_subnet_cidr = "10.10.10.0/24", vm_host_number = 10 }
  ]
}

output "bastion_node_output" {
  value = module.bastion_node.vm_list
}

