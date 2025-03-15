terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url    = var.pm_api_url
  pm_user       = var.pm_user
  pm_password   = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure
}

variable "pm_api_url" {
  description = "The URL for the Proxmox API"
  type        = string
}

variable "pm_user" {
  description = "The username for the Proxmox API"
  type        = string
}

variable "pm_password" {
  description = "The password for the Proxmox API"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Allow insecure TLS connections"
  type        = bool
  default     = true
}

variable "proxmox_host" {
  description = "The IP or hostname of the Proxmox server"
  default     = "192.168.4.54"  # Replace with the actual IP or hostname
}

variable "proxmox_password" {
  description = "The password for the Proxmox server"
  default     = "oracle"  # Replace with the actual password
}

variable "k8s_master_count" {
  description = "Number of Kubernetes master nodes"
 default     = 1
}

variable "ssh_private_key" {
  description = "Path to the SSH private key"
  default     = "~/.ssh/id_rsa"  # Replace with the actual path to your SSH private key
}

variable "master_ip" {
  description = "IP address for the master node"
  default     = "192.168.4.150/24"
}

variable "worker_1_ip" {
  description = "IP address for the first worker node"
  default     = "192.168.4.151/24"
}

variable "worker_2_ip" {
  description = "IP address for the second worker node"
  default     = "192.168.4.152/24"
}

variable "worker_3_ip" {
  description = "IP address for the third worker node"
  default     = "192.168.4.153/24"
}

resource "local_file" "master_networkdata" {
  content  = templatefile("${path.module}/networkdata.tpl", { ip_address = var.master_ip })
  filename = "${path.module}/snippets/master-networkdata.yml"
}

resource "local_file" "worker_1_networkdata" {
  content  = templatefile("${path.module}/networkdata.tpl", { ip_address = var.worker_1_ip })
  filename = "${path.module}/snippets/worker-1-networkdata.yml"
}

resource "local_file" "worker_2_networkdata" {
  content  = templatefile("${path.module}/networkdata.tpl", { ip_address = var.worker_2_ip })
  filename = "${path.module}/snippets/worker-2-networkdata.yml"
}

resource "local_file" "worker_3_networkdata" {
  content  = templatefile("${path.module}/networkdata.tpl", { ip_address = var.worker_3_ip })
  filename = "${path.module}/snippets/worker-3-networkdata.yml"
}

resource "null_resource" "upload_master_networkdata" {
  provisioner "file" {
    source      = "${path.module}/snippets/master-networkdata.yml"
    destination = "/var/lib/vz/snippets/master-networkdata.yml"
    connection {
      type     = "ssh"
      host     = var.proxmox_host
      user     = "root"
      password = var.proxmox_password
    }
  }
}

resource "null_resource" "upload_worker_1_networkdata" {
  provisioner "file" {
    source      = "${path.module}/snippets/worker-1-networkdata.yml"
    destination = "/var/lib/vz/snippets/worker-1-networkdata.yml"
    connection {
      type     = "ssh"
      host     = var.proxmox_host
      user     = "root"
      password = var.proxmox_password
    }
  }
}

resource "null_resource" "upload_worker_2_networkdata" {
  provisioner "file" {
    source      = "${path.module}/snippets/worker-2-networkdata.yml"
    destination = "/var/lib/vz/snippets/worker-2-networkdata.yml"
    connection {
      type     = "ssh"
      host     = var.proxmox_host
      user     = "root"
      password = var.proxmox_password
    }
  }
}

resource "null_resource" "upload_worker_3_networkdata" {
  provisioner "file" {
    source      = "${path.module}/snippets/worker-3-networkdata.yml"
    destination = "/var/lib/vz/snippets/worker-3-networkdata.yml"
    connection {
      type     = "ssh"
      host     = var.proxmox_host
      user     = "root"
      password = var.proxmox_password
    }
  }
}

resource "proxmox_vm_qemu" "k8s_master" {
  depends_on = [null_resource.upload_master_networkdata]
  count       = var.k8s_master_count
  name        = "k8s-master-${count.index + 1}"
  target_node = "pve"
  clone       = "rockyos"  # Replace with the actual template name
  full_clone  = true
  memory      = 4096
  cores       = 2
  scsihw      = "virtio-scsi-single"
  bios        = "seabios"
  cpu         = "x86-64-v2-AES"
  boot        = "order=scsi0"
  disk {
    size      = "32G"
    type      = "disk"
    storage   = "local-lvm"
    slot      = "scsi0"
    iothread  = true
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  serial {
    id    = 0
    type  = "socket"
  }

  cicustom = "user=local:snippets/101-userdata.yml,network=local:snippets/master-networkdata.yml"  # Path to your Cloud-Init configuration

  disk {
    size    = "4G"
    type    = "cloudinit"
    storage = "local-lvm"
    slot    = "ide2"
  }

  timeouts {
    create = "60m"
  }
}

resource "proxmox_vm_qemu" "k8s_worker_1" {
  depends_on = [
    null_resource.upload_worker_1_networkdata,
    proxmox_vm_qemu.k8s_master
  ]
  name        = "k8s-worker-1"
  target_node = "pve"
  clone       = "rockyos"  # Replace with the actual template name
  full_clone  = true
  memory      = 2048
  cores       = 2
  scsihw      = "virtio-scsi-single"
  bios        = "seabios"
  cpu         = "x86-64-v2-AES"
  boot        = "order=scsi0"
  disk {
    size      = "32G"
    type      = "disk"
    storage   = "local-lvm"
    slot      = "scsi0"
    iothread  = true
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  cicustom = "user=local:snippets/101-userdata.yml,network=local:snippets/worker-1-networkdata.yml"  # Path to your Cloud-Init configuration

  disk {
    size    = "4G"
    type    = "cloudinit"
    storage = "local-lvm"
    slot    = "ide2"
  }

  timeouts {
    create = "60m"
  }
}

resource "proxmox_vm_qemu" "k8s_worker_2" {
  depends_on = [
    null_resource.upload_worker_2_networkdata,
    proxmox_vm_qemu.k8s_worker_1
  ]
  name        = "k8s-worker-2"
  target_node = "pve"
  clone       = "rockyos"  # Replace with the actual template name
  full_clone  = true
  memory      = 2048
  cores       = 2
  scsihw      = "virtio-scsi-single"
  bios        = "seabios"
  cpu         = "x86-64-v2-AES"
  boot        = "order=scsi0"
  disk {
    size      = "32G"
    type      = "disk"
    storage   = "local-lvm"
    slot      = "scsi0"
    iothread  = true
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  cicustom = "user=local:snippets/101-userdata.yml,network=local:snippets/worker-2-networkdata.yml"  # Path to your Cloud-Init configuration

  disk {
    size    = "4G"
    type    = "cloudinit"
    storage = "local-lvm"
    slot    = "ide2"
  }

  timeouts {
    create = "60m"
  }
}

resource "proxmox_vm_qemu" "k8s_worker_3" {
  depends_on = [
    null_resource.upload_worker_3_networkdata,
    proxmox_vm_qemu.k8s_worker_2
  ]
  name        = "k8s-worker-3"
  target_node = "pve"
  clone       = "rockyos"  # Replace with the actual template name
  full_clone  = true
  memory      = 2048
  cores       = 2
  scsihw      = "virtio-scsi-single"
  bios        = "seabios"
  cpu         = "x86-64-v2-AES"
  boot        = "order=scsi0"
  disk {
    size      = "32G"
    type      = "disk"
    storage   = "local-lvm"
    slot      = "scsi0"
    iothread  = true
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  cicustom = "user=local:snippets/101-userdata.yml,network=local:snippets/worker-3-networkdata.yml"  # Path to your Cloud-Init configuration

  disk {
    size    = "4G"
    type    = "cloudinit"
    storage = "local-lvm"
    slot    = "ide2"
  }

  timeouts {
    create = "60m"
  }
}

output "k8s_master_ip" {
  value = "192.168.4.150"
}

output "k8s_worker_ips" {
  value = ["192.168.4.151", "192.168.4.152", "192.168.4.153"]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    master_ip = "192.168.4.150"
    worker_ips = ["192.168.4.151", "192.168.4.152", "192.168.4.153"]
  })
  filename = "${path.module}/inventory.ini"
}
