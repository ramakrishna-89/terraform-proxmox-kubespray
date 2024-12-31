variable "node_count" {
  type        = number
  description = "The number of nodes."
}

variable "vm_id" {
  type        = number
  description = "The VM id number "
}

variable "vm_tags" {
  type    = string
  default = ""
}

variable "pm_host" {
  type        = string
  description = "The name of Proxmox node where the VM is placed."
}

variable "vm_name_prefix" {
  type        = string
  description = "VM prefix name"
  default     = "pve"
}

variable "use_legacy_naming_convention" {
  type    = bool
  default = false
}

variable "vm_vcpus" {
  type        = number
  description = "The number of CPU cores to allocate to the VM."
  default     = 2
}

variable "vm_boot_disk_interface" {
  type        = string
  description = "The interface type of the disk"
}

variable "vm_memory_mb" {
  type        = number
  description = "The size of VM memory in MB"
  default     = 2048
}

variable "vm_boot_storage_id" {
  type        = string
  description = "The proxmox data storage id"
}

variable "vm_boot_disk_size_gb" {
  type        = number
  description = "The size of VM OS disk in Gigabyte"
  default     = 20
}

variable "vm_username" {
  type        = string
  description = "The vm login user name (default is kubeuser)."
}

variable "vm_password" {
  type        = string
  description = "The vm login user passowrd."
}

variable "vm_ssh_public_key_path" {
  type        = string
  description = "Cloud init SSH public key path."
}

variable "vm_cloud_init_file_id" {
  type        = string
  description = "Cloud init file id."
}

variable "vm_image_id" {
  type        = string
  description = "VM image (os) id"
}

variable "vm_startup_order" {
  type        = number
  description = "The startup order of the VM"
}

variable "vm_startup_delay" {
  type        = number
  description = "The startup delay of the VM"
  default     = 60
}

variable "vm_shutdown_delay" {
  type        = number
  description = "The Shutdown delay of the VM"
  default     = 60
}

variable "vm_ip_config" {
  type        = list(object({ vm_network_bridge_name = string, vm_subnet_cidr = string, vm_host_number = number }))
  description = "Network IP specification"
}

variable "vm_data_disk_config" {
  type        = list(object({ datastore_id = string, path_in_datastore = string, file_format = string, size = number, interface = string }))
  description = "Data disk specification"
  default     = []
}
