locals {
  kubespray_data_dir = "$HOME/kubespray_data"

  setup_kubespray_script_content = templatefile(
    "${path.module}/scripts/setup_kubespray.sh",
    {
      kubespray_data_dir = local.kubespray_data_dir
    }
  )

  install_kubernetes_script_content = templatefile(
    "${path.module}/scripts/install_kubernetes.sh",
    {
      kubespray_data_dir = local.kubespray_data_dir,
      kubespray_image    = var.kubespray_image
      ssh_username       = var.vm_username
    }
  )

  kubespray_inventory_content = templatefile(
    "${path.module}/kubespray/inventory.ini",
    {
      cp_nodes     = join("\n", [for host in module.kube_cplane.vm_list : join("", [host.name, " ansible_ssh_host=${host.ipv4[1]}", " ansible_connection=ssh"])])
      worker_nodes = join("\n", [for host in module.kube_worker.vm_list : join("", [host.name, " ansible_ssh_host=${host.ipv4[1]}", " ansible_connection=ssh"])])
      bastion      = "" # var.bastion_ssh_ip != "" ? "[bastion]\nbastion ansible_host=${var.bastion_ssh_ip} ansible_port=${var.bastion_ssh_port} ansible_user=${var.bastion_ssh_user}" : ""
    }
  )

  kubespray_k8s_config_content = templatefile(
    "${path.module}/kubespray/k8s-cluster.yaml",
    {
      kube_version               = var.kube_version
      kube_network_plugin        = var.kube_network_plugin
      cluster_name               = local.cluster_fqdn
      enable_nodelocaldns        = var.enable_nodelocaldns
      podsecuritypolicy_enabled  = var.podsecuritypolicy_enabled
      persistent_volumes_enabled = var.persistent_volumes_enabled
    }
  )

  kubespray_addon_config_content = templatefile(
    "${path.module}/kubespray/addons.yaml",
    {
      helm_enabled          = var.helm_enabled
      ingress_nginx_enabled = var.ingress_nginx_enabled
      argocd_enabled        = var.argocd_enabled
      argocd_version        = var.argocd_version
    }
  )

}

resource "null_resource" "setup_kubespray" {

  count = var.create_kubespray_host ? 1 : 0

  provisioner "remote-exec" {
    inline = [
      local.setup_kubespray_script_content,
      "echo \"${trimspace(data.local_file.ssh_private_key.content)}\" > ${local.kubespray_data_dir}/id_rsa",
      <<-EOT
      cat <<EOF > ${local.kubespray_data_dir}/inventory.ini
      ${local.kubespray_inventory_content}
      EOF
      EOT
      ,
      <<-EOT
      cat <<EOF > ${local.kubespray_data_dir}/k8s-cluster.yml
      ${local.kubespray_k8s_config_content}
      EOF
      EOT
      ,
      <<-EOT
      cat <<EOF > ${local.kubespray_data_dir}/addons.yml
      ${local.kubespray_addon_config_content}
      EOF
      EOT
      ,
      "chmod 600 ${local.kubespray_data_dir}/*",
      local.install_kubernetes_script_content
    ]
  }

  connection {
    type                = "ssh"
    user                = var.vm_username
    private_key         = file(var.vm_ssh_private_key_path)
    host                = module.kubespray_node.vm_list[0].ipv4[1]
    port                = 22
    bastion_host        = module.bastion_node.vm_list[0].ipv4[1]
    bastion_user        = var.vm_username
    bastion_port        = 22
    bastion_private_key = file(var.vm_ssh_private_key_path)
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    module.bastion_node,
    module.kube_cplane,
    module.kube_worker,
    module.kubespray_node
  ]

}
