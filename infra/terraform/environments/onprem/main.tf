terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = true
}


module "proxmox_vms" {
  source        = "../../modules/proxmox-vm"
  proxmox_host = var.proxmox_host
  vm_config    = var.vm_config
  storage_pool = var.storage_pool

  providers = {
    proxmox = proxmox
  }
}


module "networking" {
  source        = "../../modules/networking"
  proxmox_host = var.proxmox_host

  providers = {
    proxmox = proxmox
  }
}
