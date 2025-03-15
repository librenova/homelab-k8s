variable "ubuntu_version" {
  description = "Ubuntu version for the cloud image"
  type        = string
  default     = "22.04"
}

variable "template_id" {
  description = "Proxmox VM template ID"
  type        = number
}

variable "proxmox_node" {
  description = "The Proxmox node where the VM will be created"
  type        = string
}

variable "storage_pool" {
  description = "Proxmox storage pool to store the template"
  type        = string
}

variable "memory" {
  description = "Amount of RAM in MB"
  type        = number
  default     = 2048
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}
