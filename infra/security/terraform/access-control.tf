resource "proxmox_user" "admin" {
  userid   = "admin@pam"
  password = "securepassword"
  role     = "Administrator"
}