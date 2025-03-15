variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "proxmox_user" {
  description = "Proxmox username (e.g., root@pam)"
  type        = string
  sensitive   = true
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}


variable "ssh_public_key" {
  description = "Path to the SSH public key"
  type        = string
}

variable "template_name" {
  description = "Name of the Proxmox VM template"
  type        = string
}

variable "vm_id" {
  description = "Proxmox VM ID for the template"
  type        = number
}

variable "node" {
  description = "Proxmox node where the VM will be created"
  type        = string
}

variable "memory" {
  description = "Amount of RAM in MB"
  type        = number
  default     = 2048
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Size of the primary disk in GB"
  type        = string
  default     = "20G"
}
