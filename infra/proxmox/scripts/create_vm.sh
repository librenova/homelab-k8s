#!/bin/bash

# Proxmox API Variables
PROXMOX_HOST="your_proxmox_host"
VM_ID="100"
TEMPLATE_NAME="ubuntu-template"
STORAGE="local-lvm"

# Clone and start VM
qm clone $TEMPLATE_NAME $VM_ID --name "k8s-node-$VM_ID" --full true --storage $STORAGE
qm set $VM_ID --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0
qm start $VM_ID

echo "✅ VM k8s-node-$VM_ID created successfully!"
