resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  count       = var.node_count
  name        = var.use_legacy_naming_convention ? "${var.vm_name_prefix}-${format("%02d", count.index)}" : "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
  vm_id       = var.vm_id + count.index
  node_name   = var.pm_host
  tags        = split(";", var.vm_tags)
  description = "Ubuntu Cloud Init VM For K8 - Author: Ramakrishna"

  operating_system {
    type = "l26"
  }

  agent {
    enabled = true
    timeout = "60s"
  }

  cpu {
    cores = var.vm_vcpus
  }

  memory {
    dedicated = var.vm_memory_mb
  }

  serial_device {}

  startup {
    order      = var.vm_startup_order
    up_delay   = var.vm_startup_delay
    down_delay = var.vm_shutdown_delay
  }

  # Boot Disk
  disk {
    datastore_id = var.vm_boot_storage_id
    file_id      = var.vm_image_id
    interface    = var.vm_boot_disk_interface
    size         = var.vm_boot_disk_size_gb
    #ssd          = true
  }
  #Data Disk
  dynamic "disk" {
    for_each = var.vm_data_disk_config
    iterator = obj
    content {
      datastore_id      = obj.value.datastore_id
      path_in_datastore = obj.value.path_in_datastore
      file_format       = obj.value.file_format
      size              = obj.value.size
      interface         = obj.value.interface
      #ssd               = true
    }
  }

  dynamic "network_device" {
    for_each = var.vm_ip_config
    iterator = obj
    content {
      bridge = obj.value.vm_network_bridge_name
    }
  }

  #Cloud Init Configuration
  initialization {
    datastore_id      = var.vm_boot_storage_id
    user_data_file_id = var.vm_cloud_init_file_id
    dynamic "ip_config" {
      for_each = var.vm_ip_config
      iterator = obj
      content {
        ipv4 {
          address = "${cidrhost(obj.value.vm_subnet_cidr, obj.value.vm_host_number + count.index)}/${split("/", obj.value.vm_subnet_cidr)[1]}"
          gateway = cidrhost(obj.value.vm_subnet_cidr, 1)
        }
      }
    }
  }
}


