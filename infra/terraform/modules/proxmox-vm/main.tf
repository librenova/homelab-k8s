terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {}

resource "proxmox_vm_qemu" "k8s_nodes" {
  count       = length(var.vm_config)
  name        = var.vm_config[count.index].name
  target_node = "pve"
  clone       = "ubuntu-cloudinit-template"
  full_clone  = true
  memory      = var.vm_config[count.index].memory
  cores       = var.vm_config[count.index].cores

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    size    = var.vm_config[count.index].disk_size
    type    = "disk"
    storage = var.storage_pool
    slot    = "scsi0"
    iothread = true
  }
}
