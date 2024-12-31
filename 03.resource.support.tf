resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.pm_host
  url          = var.vm_image_download_url
}

data "local_file" "ssh_public_key" {
  filename = var.vm_ssh_public_key_path
}

data "local_file" "ssh_private_key" {
  filename = var.vm_ssh_private_key_path
}
resource "proxmox_virtual_environment_file" "ubuntu_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pm_host
  overwrite    = true
  source_raw {
    data = templatefile(var.vm_cloud_init_file_path, {
      vm_username = "${var.vm_username}",
      vm_password = "${var.vm_password}",
      vm_sshkey   = "${trimspace(data.local_file.ssh_public_key.content)}",
    })
    file_name = "cloud-init-data.yml"
  }

}
