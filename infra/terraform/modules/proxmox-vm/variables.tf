variable "proxmox_api_url" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox username"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "The Proxmox node where the VM will be created"
  type        = string
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "template" {
  description = "Proxmox template to clone"
  type        = string
}

variable "full_clone" {
  description = "Set to true for full clone"
  type        = bool
  default     = false
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = string
  default     = "50G"
}

variable "storage_pool" {
  description = "Storage pool to use for VM"
  type        = string
}

variable "network_bridge" {
  description = "Network bridge to attach the VM to"
  type        = string
  default     = "vmbr0"
}
