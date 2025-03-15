variable "proxmox_host" {
  description = "Proxmox server IP or hostname"
  type        = string
}

variable "storage_pool" {
  description = "Storage pool to be used for Proxmox VMs"
  type        = string
  default     = "local-lvm"
}

variable "vm_config" {
  description = "List of virtual machines to create"
  type = list(object({
    name        = string
    role        = string   # "master" or "worker"
    memory      = number
    cores       = number
    disk_size   = string
    network_ip  = string
  }))
  default = [
    { name = "k8s-master-1", role = "master", memory = 8192, cores = 4, disk_size = "40G", network_ip = "192.168.4.150/24" },
    { name = "k8s-worker-1", role = "worker", memory = 4096, cores = 2, disk_size = "40G", network_ip = "192.168.4.151/24" },
    { name = "k8s-worker-2", role = "worker", memory = 4096, cores = 2, disk_size = "40G", network_ip = "192.168.4.152/24" }
  ]
}
