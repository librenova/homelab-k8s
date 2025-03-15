
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {}


resource "proxmox_network" "vlan" {
  bridge    = var.network_bridge
  vlan_tag  = var.vlan_id
  autostart = true
}
