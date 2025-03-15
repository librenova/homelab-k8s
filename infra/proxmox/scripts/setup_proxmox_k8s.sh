#!/bin/bash

# Variables
TEMPLATE_ID=9000
TEMPLATE_NAME="ubuntu-22-cloud"
PROXMOX_STORAGE="local-lvm"
CLOUD_IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
CLOUD_IMAGE_FILE="jammy-server-cloudimg-amd64.img"

# Step 1: Download Ubuntu 22.04 Cloud-Init Image
echo "📥 Downloading Ubuntu 22.04 Cloud-Init image..."
wget -O $CLOUD_IMAGE_FILE $CLOUD_IMAGE_URL

# Step 2: Create a new VM in Proxmox
echo "🖥 Creating VM Template with ID: $TEMPLATE_ID"
qm create $TEMPLATE_ID --name $TEMPLATE_NAME --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0

# Step 3: Import the Cloud-Init Image as a Disk
echo "💾 Importing Cloud-Init disk..."
qm importdisk $TEMPLATE_ID $CLOUD_IMAGE_FILE $PROXMOX_STORAGE

# Step 4: Configure VM to use imported disk
echo "🛠 Setting up VM..."
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 $PROXMOX_STORAGE:vm-$TEMPLATE_ID-disk-0

# Step 5: Configure Cloud-Init settings
echo "⚙ Enabling Cloud-Init Support..."
qm set $TEMPLATE_ID --ide2 $PROXMOX_STORAGE:cloudinit
qm set $TEMPLATE_ID --boot c --bootdisk scsi0
qm set $TEMPLATE_ID --serial0 socket --vga serial0
qm set $TEMPLATE_ID --agent enabled=1

# Step 6: Convert to Template
echo "📌 Converting VM to a template..."
qm template $TEMPLATE_ID

# Step 7: Cleanup downloaded image
rm -f $CLOUD_IMAGE_FILE

echo "✅ Proxmox Cloud-Init Template ($TEMPLATE_NAME) Created Successfully!"
