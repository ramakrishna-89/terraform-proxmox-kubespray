module "kubespray_node" {
  source                 = "./modules/ubuntu-vm-module"
  depends_on             = [module.bastion_node, module.kube_cplane, module.kube_worker]
  node_count             = var.create_kubespray_host ? 1 : 0
  vm_name_prefix         = var.use_legacy_naming_convention ? "${var.env_name}-kubespray" : "vm-${local.cluster_name}-kubespray"
  vm_id                  = 401
  pm_host                = var.pm_host
  vm_image_id            = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
  vm_cloud_init_file_id  = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  vm_vcpus               = 4
  vm_memory_mb           = 2048
  vm_boot_disk_interface = "virtio0"
  vm_boot_disk_size_gb   = 50
  vm_boot_storage_id     = var.vm_boot_storage_id
  vm_ip_config           = [{ vm_network_bridge_name = "vmbr1", vm_subnet_cidr = "10.10.10.0/24", vm_host_number = 40 }]
  vm_startup_order       = 1
  vm_username            = var.vm_username
  vm_password            = var.vm_password
  vm_ssh_public_key_path = var.vm_ssh_public_key_path
  vm_tags                = "${var.env_name};terraform;kubespray_node;ramakrishna"
}

output "kubespray_host_output" {
  value = module.kubespray_node.vm_list
}

