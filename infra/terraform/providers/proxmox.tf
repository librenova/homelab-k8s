terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}


provider "proxmox" {
    endpoint = ""https://192.168.4.54:8006/"
  insecure = true # Set to false if using valid SSL certificates
  
  api_token  = var.proxmox_api_token
  pm_tls_insecure = true
}

