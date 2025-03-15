terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.4.54:8006/api2/json"
  pm_tls_insecure = true
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
}




module "ubuntu_template" {
  source = "../../../../modules/proxmox-vm-template"  # Ensure this path is correct

  ssh_public_key = file("~/.ssh/id_rsa.pub")   # ✅ Provide SSH key
  template_name  = "ubuntu-22.04-template"     # ✅ Provide a template name
  vm_id          = 9000                        # ✅ Assign a Proxmox VM ID
  node           = "pve"                        # ✅ Define Proxmox node

  memory        = 4096  # Customize memory
  cpu_cores     = 4
  disk_size     = "50G"

  providers = {
    proxmox = proxmox
  }
}
