module "kube_cplane" {
  source                 = "./modules/ubuntu-vm-module"
  depends_on             = [module.bastion_node]
  node_count             = var.vm_k8s_control_plane["node_count"]
  vm_name_prefix         = var.use_legacy_naming_convention ? "${var.env_name}-k8s-cp" : "vm-${local.cluster_name}-cp"
  vm_id                  = 420
  pm_host                = var.pm_host
  vm_image_id            = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
  vm_cloud_init_file_id  = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  vm_vcpus               = var.vm_k8s_control_plane["vcpus"]
  vm_boot_storage_id     = var.vm_boot_storage_id
  vm_memory_mb           = var.vm_k8s_control_plane["memory"]
  vm_boot_disk_interface = var.vm_k8s_control_plane["boot_disk_interface"]
  vm_boot_disk_size_gb   = var.vm_k8s_control_plane["boot_disk_size"]
  vm_ip_config           = [{ vm_network_bridge_name = "vmbr0", vm_subnet_cidr = "192.168.20.0/24", vm_host_number = 40 }]
  vm_startup_order       = 1
  vm_username            = var.vm_username
  vm_password            = var.vm_password
  vm_ssh_public_key_path = var.vm_ssh_public_key_path
  vm_tags                = "${var.env_name};terraform;k8s_control_plane;ramakrishna"
}

output "kube_cplane_output" {
  value = module.kube_cplane.vm_list
}

module "kube_worker" {
  source                 = "./modules/ubuntu-vm-module"
  depends_on             = [module.bastion_node]
  node_count             = var.vm_k8s_worker["node_count"]
  vm_name_prefix         = var.use_legacy_naming_convention ? "${var.env_name}-k8s-wr" : "vm-${local.cluster_name}-wr"
  vm_id                  = 430
  pm_host                = var.pm_host
  vm_image_id            = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
  vm_cloud_init_file_id  = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  vm_vcpus               = var.vm_k8s_worker["vcpus"]
  vm_memory_mb           = var.vm_k8s_worker["memory"]
  vm_boot_disk_interface = var.vm_k8s_worker["boot_disk_interface"]
  vm_boot_disk_size_gb   = var.vm_k8s_worker["boot_disk_size"]
  vm_boot_storage_id     = var.vm_boot_storage_id
  vm_ip_config           = [{ vm_network_bridge_name = "vmbr0", vm_subnet_cidr = "192.168.20.0/24", vm_host_number = 50 }]
  vm_startup_order       = 2
  vm_username            = var.vm_username
  vm_password            = var.vm_password
  vm_ssh_public_key_path = var.vm_ssh_public_key_path
  vm_tags                = "${var.env_name};terraform;k8s_worker_node;ramakrishna"
}

output "kube_worker_output" {
  value = module.kube_worker.vm_list
}
