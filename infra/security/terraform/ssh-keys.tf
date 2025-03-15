resource "proxmox_ssh_key" "user_key" {
  user    = "root"
  key     = file("~/.ssh/id_rsa.pub")
}