#!/bin/bash

# Variables
TEMPLATE_ID=9001
TEMPLATE_NAME="ubuntu-template"
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_PATH="/var/lib/vz/template/qcow2/ubuntu-22.04-cloudimg.qcow2"
STORAGE_POOL="local-lvm"

echo "🚀 Starting Proxmox Cloud Image Template Setup..."

# Ensure the QCOW2 directory exists
if [ ! -d "/var/lib/vz/template/qcow2/" ]; then
    echo "📁 Creating directory for cloud images..."
    mkdir -p /var/lib/vz/template/qcow2/
fi

# Download the cloud image if it doesn't exist
if [ ! -f "$IMAGE_PATH" ]; then
    echo "⬇ Downloading Ubuntu 22.04 Cloud Image..."
    wget -O $IMAGE_PATH $IMAGE_URL
else
    echo "✅ Cloud image already exists, skipping download."
fi

# Create VM if it doesn't already exist
if qm list | grep -q $TEMPLATE_ID; then
    echo "⚠ VM ID $TEMPLATE_ID already exists. Skipping VM creation."
else
    echo "🛠 Creating VM shell..."
    qm create $TEMPLATE_ID --name $TEMPLATE_NAME --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0 --ostype l26
fi

# Import the QCOW2 disk
if ! qm config $TEMPLATE_ID | grep -q "scsi0"; then
    echo "📦 Importing disk into Proxmox storage ($STORAGE_POOL)..."
    qm importdisk $TEMPLATE_ID $IMAGE_PATH $STORAGE_POOL
else
    echo "✅ Disk already imported, skipping import."
fi

# Attach the imported disk
echo "🔗 Attaching disk to VM..."
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE_POOL:vm-${TEMPLATE_ID}-disk-0

# Attach cloud-init drive
echo "☁ Attaching cloud-init drive..."
qm set $TEMPLATE_ID --ide2 $STORAGE_POOL:cloudinit

# Set boot order (fix for 'invalid bootorder' error)
echo "🛠 Configuring boot order..."
qm set $TEMPLATE_ID --boot order=scsi0

# Enable serial console for cloud-init compatibility
echo "💻 Enabling serial console..."
qm set $TEMPLATE_ID --serial0 socket --vga serial0

# Configure cloud-init
echo "⚙ Configuring cloud-init..."
qm set $TEMPLATE_ID --ciuser ubuntu --cipassword 'ChangeMe123!' --ipconfig0 ip=dhcp
qm set $TEMPLATE_ID --sshkey ~/.ssh/id_rsa.pub

# Convert to template
echo "🔄 Converting VM to template..."
qm stop $TEMPLATE_ID
qm template $TEMPLATE_ID

echo "✅ Proxmox Cloud Image Template ($TEMPLATE_NAME) Created Successfully!"
