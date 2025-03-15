#!/bin/bash

# Define the root Proxmox directory
PROXMOX_DIR="proxmox"

# Define all required subdirectories
declare -a FOLDERS=(
    "$PROXMOX_DIR/terraform"
    "$PROXMOX_DIR/cloud-init"
    "$PROXMOX_DIR/scripts"
    "$PROXMOX_DIR/backups"
    "$PROXMOX_DIR/networking"
)

# Create folders
for folder in "${FOLDERS[@]}"; do
    mkdir -p "$folder"
done

# Create README files for each major section
echo "# 🖥️ Proxmox VM Automation" > "$PROXMOX_DIR/README.md"
echo "# 📂 Terraform Configuration for Proxmox" > "$PROXMOX_DIR/terraform/README.md"
echo "# 🌩️ Cloud-Init Templates" > "$PROXMOX_DIR/cloud-init/README.md"
echo "# 🔧 Proxmox Automation Scripts" > "$PROXMOX_DIR/scripts/README.md"
echo "# 📡 Proxmox Networking Configuration" > "$PROXMOX_DIR/networking/README.md"
echo "# 💾 Proxmox Backups" > "$PROXMOX_DIR/backups/README.md"

# --- Sample Terraform Configuration for Proxmox VM Provisioning ---
cat <<EOF > "$PROXMOX_DIR/terraform/proxmox-vm.tf"
provider "proxmox" {
  pm_api_url  = var.proxmox_api_url
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "k8s_node" {
  name        = var.vm_name
  target_node = var.proxmox_node
  clone       = var.template
  full_clone  = var.full_clone
  cores       = var.cpu_cores
  memory      = var.memory

  disk {
    size    = var.disk_size
    storage = var.storage_pool
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'VM Created Successfully!'"
    ]
  }
}
EOF

cat <<EOF > "$PROXMOX_DIR/terraform/variables.tf"
variable "proxmox_api_url" { type = string }
variable "proxmox_user" { type = string }
variable "proxmox_password" { type = string }
variable "proxmox_node" { type = string }
variable "vm_name" { type = string }
variable "template" { type = string }
variable "full_clone" { type = bool }
variable "cpu_cores" { type = number }
variable "memory" { type = number }
variable "disk_size" { type = string }
variable "storage_pool" { type = string }
variable "network_bridge" { type = string }
EOF

# --- Sample Cloud-Init Configuration ---
cat <<EOF > "$PROXMOX_DIR/cloud-init/user-data.yaml"
#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    ssh_authorized_keys:
      - ssh-rsa AAAAB3...your_public_ssh_key
EOF

cat <<EOF > "$PROXMOX_DIR/cloud-init/meta-data.yaml"
instance-id: proxmox-vm-01
local-hostname: proxmox-node
EOF

# --- Sample Proxmox Automation Scripts ---
cat <<EOF > "$PROXMOX_DIR/scripts/create_vm.sh"
#!/bin/bash

# Proxmox API Variables
PROXMOX_HOST="your_proxmox_host"
VM_ID="100"
TEMPLATE_NAME="ubuntu-template"
STORAGE="local-lvm"

# Clone and start VM
qm clone \$TEMPLATE_NAME \$VM_ID --name "k8s-node-\$VM_ID" --full true --storage \$STORAGE
qm set \$VM_ID --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0
qm start \$VM_ID

echo "✅ VM k8s-node-\$VM_ID created successfully!"
EOF
chmod +x "$PROXMOX_DIR/scripts/create_vm.sh"

cat <<EOF > "$PROXMOX_DIR/scripts/delete_vm.sh"
#!/bin/bash

# Proxmox API Variables
VM_ID="\$1"

if [ -z "\$VM_ID" ]; then
  echo "❌ Error: Please provide a VM ID to delete."
  exit 1
fi

qm stop \$VM_ID
qm destroy \$VM_ID

echo "✅ VM \$VM_ID deleted successfully!"
EOF
chmod +x "$PROXMOX_DIR/scripts/delete_vm.sh"

# --- Sample Proxmox Networking Configuration ---
cat <<EOF > "$PROXMOX_DIR/networking/proxmox-network-config.yaml"
auto vmbr0
iface vmbr0 inet static
  address 192.168.1.1
  netmask 255.255.255.0
  bridge_ports eno1
  bridge_stp off
  bridge_fd 0
EOF

# --- Sample Backup Script ---
cat <<EOF > "$PROXMOX_DIR/backups/backup_vm.sh"
#!/bin/bash

# Proxmox Backup Variables
VM_ID="\$1"
BACKUP_DIR="/var/lib/vz/dump"

if [ -z "\$VM_ID" ]; then
  echo "❌ Error: Please provide a VM ID to backup."
  exit 1
fi

vzdump \$VM_ID --dumpdir \$BACKUP_DIR --compress zstd

echo "✅ VM \$VM_ID backup completed successfully!"
EOF
chmod +x "$PROXMOX_DIR/backups/backup_vm.sh"

# Initialize Git repository
cd "$PROXMOX_DIR"
git init
git add .
git commit -m "Initial commit: Proxmox setup with Terraform, Cloud-Init, and automation scripts"

echo "✅ Proxmox folder structure and sample files created successfully."
