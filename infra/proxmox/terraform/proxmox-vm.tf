provider "proxmox" {
  pm_api_url  = var.proxmox_api_url
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "k8s_node" {
  name        = var.vm_name
  target_node = var.proxmox_node
  clone       = var.template
  full_clone  = var.full_clone
  cores       = var.cpu_cores
  memory      = var.memory

  disk {
    size    = var.disk_size
    storage = var.storage_pool
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'VM Created Successfully!'"
    ]
  }
}
