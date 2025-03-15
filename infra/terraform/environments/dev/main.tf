module "proxmox_templates" {
  source = "../../modules/proxmox-vm-template"
  proxmox_node = "pve"
}

module "kubernetes" {
  source       = "../../modules/kubernetes"
  proxmox_node = "pve"
  k8s_template = module.proxmox_templates.ubuntu_template
  worker_count = 2
}
