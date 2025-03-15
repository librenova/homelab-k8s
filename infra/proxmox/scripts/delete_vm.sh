#!/bin/bash

# Proxmox API Variables
VM_ID="$1"

if [ -z "$VM_ID" ]; then
  echo "❌ Error: Please provide a VM ID to delete."
  exit 1
fi

qm stop $VM_ID
qm destroy $VM_ID

echo "✅ VM $VM_ID deleted successfully!"
