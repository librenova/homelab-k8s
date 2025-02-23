#!/bin/bash

# Define available OS options and their corresponding download links
declare -A OS_IMAGES=(
    ["ubuntu-22.04"]="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    ["ubuntu-20.04"]="https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
    ["debian-11"]="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
    ["debian-12"]="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    ["rocky-8"]="https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"
    ["rocky-9"]="https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
    ["almalinux-8"]="https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2"
    ["almalinux-9"]="https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
)


# User selection menu
echo "📌 Select an OS for the Proxmox Cloud-Init Template:"
select OS in "${!OS_IMAGES[@]}"; do
    if [[ -n "$OS" ]]; then
        IMAGE_URL="${OS_IMAGES[$OS]}"
        TEMPLATE_NAME="${OS}-cloud"
        break
    else
        echo "❌ Invalid selection. Please try again."
    fi
done

# Find the next available VM ID
NEXT_VM_ID=$(pvesh get /cluster/nextid)
echo "📌 Using VM ID: $NEXT_VM_ID"

PROXMOX_STORAGE="local-lvm"
CLOUD_IMAGE_FILE="${TEMPLATE_NAME}.qcow2"

# Step 1: Download the selected Cloud-Init image
echo "📥 Downloading ${OS} Cloud-Init image..."
wget -O $CLOUD_IMAGE_FILE $IMAGE_URL

# Check if the file was downloaded successfully and is a valid image
if [ ! -f "$CLOUD_IMAGE_FILE" ] || [ ! -s "$CLOUD_IMAGE_FILE" ]; then
    echo "❌ ERROR: Failed to download ${OS} Cloud-Init image. Exiting..."
    rm -f "$CLOUD_IMAGE_FILE"
    exit 1
fi

# Step 2: Create a new VM in Proxmox
echo "🖥 Creating VM Template with ID: $NEXT_VM_ID"
qm create $NEXT_VM_ID --name $TEMPLATE_NAME --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0

# Step 3: Import the Cloud-Init Image as a Disk
echo "💾 Importing Cloud-Init disk..."
qm importdisk $NEXT_VM_ID $CLOUD_IMAGE_FILE $PROXMOX_STORAGE

# Step 4: Configure VM to use imported disk
echo "🛠 Setting up VM..."
qm set $NEXT_VM_ID --scsihw virtio-scsi-pci --scsi0 $PROXMOX_STORAGE:vm-$NEXT_VM_ID-disk-0

# Step 5: Configure Cloud-Init settings
echo "⚙ Enabling Cloud-Init Support..."
qm set $NEXT_VM_ID --ide2 $PROXMOX_STORAGE:cloudinit
qm set $NEXT_VM_ID --boot c --bootdisk scsi0
qm set $NEXT_VM_ID --serial0 socket --vga serial0
qm set $NEXT_VM_ID --agent enabled=1

# Step 6: Convert to Template
echo "📌 Converting VM to a template..."
qm template $NEXT_VM_ID

# Step 7: Cleanup downloaded image
rm -f $CLOUD_IMAGE_FILE

echo "✅ Proxmox Cloud-Init Template for ${OS} Created Successfully! VM ID: $NEXT_VM_ID"
