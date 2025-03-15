terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

resource "null_resource" "download_ubuntu_image" {
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p /var/lib/vz/template/qcow2/
      
      if [ ! -f "/var/lib/vz/template/qcow2/ubuntu-${var.ubuntu_version}-cloudimg.qcow2" ]; then
        echo "Downloading Ubuntu ${var.ubuntu_version} Cloud Image..."
        wget -O /var/lib/vz/template/qcow2/ubuntu-${var.ubuntu_version}-cloudimg.qcow2 \
        https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
      fi
    EOT
  }
}

resource "null_resource" "convert_ubuntu_template" {
  depends_on = [null_resource.download_ubuntu_image]
  provisioner "local-exec" {
    command = <<EOT
      qm create ${var.template_id} --name ubuntu-${var.ubuntu_version}-template --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
      qm importdisk ${var.template_id} /var/lib/vz/template/qcow2/ubuntu-${var.ubuntu_version}-cloudimg.qcow2 ${var.storage_pool}
      qm set ${var.template_id} --scsihw virtio-scsi-pci --scsi0 ${var.storage_pool}:vm-${var.template_id}-disk-0
      qm set ${var.template_id} --ide2 ${var.storage_pool}:cloudinit
      qm set ${var.template_id} --boot order=scsi0
      qm set ${var.template_id} --serial0 socket --vga serial0
      qm set ${var.template_id} --ciuser ubuntu --cipassword 'ChangeMe123!' --ipconfig0 ip=dhcp
      qm stop ${var.template_id}
      qm template ${var.template_id}
    EOT
  }
}


resource "proxmox_vm_qemu" "ubuntu_template" {
  name        = var.template_name
  vmid        = var.vm_id
  target_node = var.node
  clone       = "ubuntu-22.04-cloudimg"
  full_clone  = true
  memory      = var.memory
  cores       = var.cpu_cores

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    size    = var.disk_size
    type    = "disk"    # ✅ Use "disk" instead of "virtio"
    storage = "local-lvm"
    slot    = "virtio0" # ✅ Use a valid slot
  }

  cicustom = "user=local:snippets/cloud-init.yaml,network=local:snippets/networkdata.yml"

  disk {
    size    = "4G"
    type    = "cloudinit"
    storage = "local-lvm"
    slot    = "ide2"
  }
}
