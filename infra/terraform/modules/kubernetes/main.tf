resource "proxmox_vm_qemu" "k8s_master" {
  name        = "k8s-master"
  target_node = var.proxmox_node
  clone       = var.k8s_template
  vmid        = 100
  memory      = 8192
  cores       = 4
}

resource "proxmox_vm_qemu" "k8s_worker" {
  count       = var.worker_count
  name        = "k8s-worker-${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.k8s_template
  vmid        = 200 + count.index
  memory      = 4096
  cores       = 2
}

resource "null_resource" "ansible_provisioning" {
  depends_on = [proxmox_vm_qemu.k8s_master, proxmox_vm_qemu.k8s_worker]
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${path.module}/ansible/inventory.ini ${path.module}/ansible/playbook.yml"
  }
}
