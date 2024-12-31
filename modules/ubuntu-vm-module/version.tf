terraform {
  required_version = "~> 1.10.2"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.68.1"
    }
  }
}
