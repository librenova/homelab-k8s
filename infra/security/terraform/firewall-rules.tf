resource "proxmox_firewall_rule" "allow_ssh" {
  node   = "pve"
  action = "ACCEPT"
  proto  = "tcp"
  dport  = "22"
  source = "192.168.1.0/24"
}