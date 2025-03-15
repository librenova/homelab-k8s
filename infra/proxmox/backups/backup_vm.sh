#!/bin/bash

# Proxmox Backup Variables
VM_ID="$1"
BACKUP_DIR="/var/lib/vz/dump"

if [ -z "$VM_ID" ]; then
  echo "❌ Error: Please provide a VM ID to backup."
  exit 1
fi

vzdump $VM_ID --dumpdir $BACKUP_DIR --compress zstd

echo "✅ VM $VM_ID backup completed successfully!"
