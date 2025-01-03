# Environment
########################################################################
variable "env_name" {
  type        = string
  description = "The stage of the development lifecycle for the k8s cluster. Example: `prod`, `dev`, `qa`, `stage`, `test`"
  default     = "test"
}

variable "location" {
  type        = string
  description = "The city or region where the cluster is provisioned"
  default     = null
}

variable "cluster_number" {
  type        = string
  description = "The instance count for the k8s cluster, to differentiate it from other clusters. Example: `00`, `01`"
  default     = "01"
}

variable "cluster_domain" {
  type        = string
  description = "The cluster domain name"
  default     = "local"
}

locals {
  cluster_name = var.location != null ? "k8s-${var.env_name}-${var.location}-${var.cluster_number}" : "k8s-${var.env_name}-${var.cluster_number}"
  cluster_fqdn = "${local.cluster_name}.${var.cluster_domain}"
}

variable "use_legacy_naming_convention" {
  type        = bool
  description = "Whether to use legacy naming convention for the VM and cluster name. If your cluster was provisioned using version <= 3.x, set it to `true`"
  default     = false
}

# Proxmox
########################################################################

variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox end point"
}

variable "proxmox_insecure" {
  type        = bool
  description = "Proxmox end point"
  default     = false
}

variable "proxmox_username" {
  type        = string
  description = "Proxmox username"
}

variable "proxmox_password" {
  type        = string
  description = "Proxmox password"
}

variable "proxmox_ssh_agent" {
  type        = bool
  description = "Proxmox ssh agent"
  default     = false
}

# Kuberentes VM specifications for Kubernetes nodes
########################################################################
variable "vm_k8s_control_plane" {
  type        = object({ node_count = number, vcpus = number, memory = number, boot_disk_size = number, boot_disk_interface = string })
  description = "Control Plane VM specification"
  default     = { node_count = 1, vcpus = 2, memory = 1024, boot_disk_size = 25, boot_disk_interface = "virtio0" }
}

variable "vm_k8s_worker" {
  type        = object({ node_count = number, vcpus = number, memory = number, boot_disk_size = number, boot_disk_interface = string })
  description = "Worker VM specification"
  default     = { node_count = 2, vcpus = 2, memory = 2048, boot_disk_size = 50, boot_disk_interface = "virtio0" }
}

# Kubernetes settings
########################################################################
variable "create_kubespray_host" {
  type        = bool
  description = "Whether to provision the Kubespray as a VM"
  default     = true
}

variable "kubespray_image" {
  type        = string
  description = "The Docker image to deploy Kubespray"
  default     = "quay.io/kubespray/kubespray:v2.26.0"
}

variable "kube_version" {
  type        = string
  description = "Kubernetes version"
  default     = "v1.32.0"
}
variable "kube_network_plugin" {
  type        = string
  description = "The network plugin to be installed on your cluster. Example: `cilium`, `calico`, `kube-ovn`, `weave` or `flannel`"
  default     = "calico"
}

variable "enable_nodelocaldns" {
  type        = bool
  description = "Whether to enable nodelocal dns cache on your cluster"
  default     = false
}
variable "podsecuritypolicy_enabled" {
  type        = bool
  description = "Whether to enable pod security policy on your cluster (RBAC must be enabled either by having 'RBAC' in authorization_modes or kubeadm enabled)"
  default     = false
}
variable "persistent_volumes_enabled" {
  type        = bool
  description = "Whether to add Persistent Volumes Storage Class for corresponding cloud provider (supported: in-tree OpenStack, Cinder CSI, AWS EBS CSI, Azure Disk CSI, GCP Persistent Disk CSI)"
  default     = false
}
variable "helm_enabled" {
  type        = bool
  description = "Whether to enable Helm on your cluster"
  default     = false
}
variable "ingress_nginx_enabled" {
  type        = bool
  description = "Whether to enable Nginx ingress on your cluster"
  default     = false
}
variable "argocd_enabled" {
  type        = bool
  description = "Whether to enable ArgoCD on your cluster"
  default     = false
}
variable "argocd_version" {
  type        = string
  description = "The ArgoCD version to be installed"
  default     = "v2.13.2"
}

# Infrastructure
########################################################################
variable "pm_host" {
  type        = string
  description = "The name of Proxmox node where the VM is placed."
}

variable "vm_boot_storage_id" {
  type        = string
  description = "The proxmox data storage id"
}

variable "vm_cloud_init_file_path" {
  type        = string
  description = "Cloud init file path."
}

variable "vm_ssh_public_key_path" {
  type        = string
  description = "Cloud init SSH public key path."
}

variable "vm_ssh_private_key_path" {
  type        = string
  description = "Cloud init SSH private key path."
}

variable "vm_image_download_url" {
  type        = string
  description = "The ubuntu iso image url (default is ubuntu noble)."
}

variable "vm_username" {
  type        = string
  description = "The vm login user name (default is kubeuser)."
}

variable "vm_password" {
  type        = string
  description = "The vm login user passowrd (provide cloud-init password hash, default is kube@123)."

}

# Node Configuration
########################################################
variable "node_config" {
  description = "The node module configuration"
  type = object({
    node_count             = number
    vm_name_prefix         = string
    vm_id                  = number
    pm_host                = string
    vm_image_id            = string
    vm_cloud_init_file_id  = string
    vm_vcpus               = number
    vm_memory_mb           = number
    vm_boot_disk_interface = string
    vm_boot_disk_size_gb   = number
    vm_boot_storage_id     = string
    vm_startup_order       = number
    vm_username            = string
    vm_password            = string
    vm_ssh_public_key_path = string
    vm_tags                = string
    vm_ip_config           = list(object({ vm_network_bridge_name = string, vm_subnet_cidr = string, vm_host_number = number }))
  })
}
