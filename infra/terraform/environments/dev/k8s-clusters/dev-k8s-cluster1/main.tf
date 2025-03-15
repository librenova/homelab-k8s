module "dev_k8s_cluster1" {
  source       = "../../../../modules/kubernetes"
  proxmox_node = "pve"
  k8s_template = module.dev_ubuntu_template.template_name
  worker_count = 2
}
