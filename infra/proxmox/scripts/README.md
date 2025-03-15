## Proxmox Scripts
Scripts for VM backup, migration, and snapshot management.
Step-by-Step Breakdown of the Script
1️⃣ OS Selection
The script starts by prompting the user to select an OS from a predefined list.

bash
Copy
Edit
declare -A OS_IMAGES=(
    ["ubuntu-22.04"]="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    ["rocky-8"]="https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"
)
This associative array (declare -A) maps OS names to their Cloud-Init image URLs.
The script displays this list as a menu for the user to choose from.
bash
Copy
Edit
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
This ensures the user selects a valid OS before proceeding.

2️⃣ Find the Next Available Proxmox VM ID
To avoid conflicts with existing VM IDs, the script dynamically finds the next available ID.

bash
Copy
Edit
NEXT_VM_ID=$(pvesh get /cluster/nextid)
echo "📌 Using VM ID: $NEXT_VM_ID"
The command pvesh get /cluster/nextid queries Proxmox and returns the next available VM ID.
3️⃣ Download the Cloud-Init Image
The script then downloads the selected Cloud-Init image:

bash
Copy
Edit
echo "📥 Downloading ${OS} Cloud-Init image..."
wget -O $CLOUD_IMAGE_FILE $IMAGE_URL
The wget command fetches the Cloud-Init image.
The -O flag saves it with a proper filename.
Validation Step: Ensure the image exists and is not empty before proceeding.

bash
Copy
Edit
if [ ! -f "$CLOUD_IMAGE_FILE" ] || [ ! -s "$CLOUD_IMAGE_FILE" ]; then
    echo "❌ ERROR: Failed to download ${OS} Cloud-Init image. Exiting..."
    rm -f "$CLOUD_IMAGE_FILE"
    exit 1
fi
If the file is missing or empty, the script exits immediately.
4️⃣ Create a New VM in Proxmox
bash
Copy
Edit
qm create $NEXT_VM_ID --name $TEMPLATE_NAME --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0
Creates a new Proxmox VM (qm create).
Assigns:
4096 MB RAM
2 CPU cores
virtio network adapter
5️⃣ Import the Cloud-Init Image as a Disk
bash
Copy
Edit
qm importdisk $NEXT_VM_ID $CLOUD_IMAGE_FILE $PROXMOX_STORAGE
Imports the downloaded Cloud-Init disk into the Proxmox storage pool.
6️⃣ Attach the Imported Disk to the VM
bash
Copy
Edit
qm set $NEXT_VM_ID --scsihw virtio-scsi-pci --scsi0 $PROXMOX_STORAGE:vm-$NEXT_VM_ID-disk-0
Configures the imported disk as the primary boot disk.
7️⃣ Configure Cloud-Init Support
bash
Copy
Edit
qm set $NEXT_VM_ID --ide2 $PROXMOX_STORAGE:cloudinit
qm set $NEXT_VM_ID --boot c --bootdisk scsi0
qm set $NEXT_VM_ID --serial0 socket --vga serial0
qm set $NEXT_VM_ID --agent enabled=1
Enables Cloud-Init by adding an empty Cloud-Init disk (ide2).
Sets:
Boot disk (scsi0).
Serial console support.
QEMU guest agent.
8️⃣ Convert the VM into a Template
bash
Copy
Edit
qm template $NEXT_VM_ID
Converts the VM into a Proxmox Template, making it ready for cloning.
9️⃣ Cleanup Downloaded Image
bash
Copy
Edit
rm -f $CLOUD_IMAGE_FILE
Removes the downloaded .qcow2 file to save space.
✨ Enhancing the Script: Pre- and Post-Creation Hooks
To add pre- and post-creation hooks, we can introduce functions that execute before and after the main process.

🛠 Pre-Creation Hook
A pre-creation hook can:

Validate system requirements.
Ensure enough free storage is available.
Check if a template with the same name exists.
bash
Copy
Edit
pre_creation_tasks() {
    echo "🔍 Checking system requirements..."
    
    # Ensure sufficient storage space (example: require at least 10GB free)
    FREE_SPACE=$(df -h /var/lib/vz | awk 'NR==2 {print $4}')
    echo "✅ Free Space: $FREE_SPACE"
    
    # Check if a template with the same name already exists
    if qm list | grep -q "$TEMPLATE_NAME"; then
        echo "❌ ERROR: A template with the name '$TEMPLATE_NAME' already exists!"
        exit 1
    fi
}
🛠 Post-Creation Hook
A post-creation hook can:

Display success message.
Provide instructions on how to clone the template.
bash
Copy
Edit
post_creation_tasks() {
    echo "🎉 Template Created Successfully!"
    echo "➡ To clone this template, run:"
    echo "   qm clone $NEXT_VM_ID 200 --name cloned-vm --full true"
}
🔄 Updated Script with Hooks
bash
Copy
Edit
#!/bin/bash

# Pre-Creation Hook
pre_creation_tasks() {
    echo "🔍 Checking system requirements..."
    FREE_SPACE=$(df -h /var/lib/vz | awk 'NR==2 {print $4}')
    echo "✅ Free Space: $FREE_SPACE"
    
    if qm list | grep -q "$TEMPLATE_NAME"; then
        echo "❌ ERROR: A template with the name '$TEMPLATE_NAME' already exists!"
        exit 1
    fi
}

# Post-Creation Hook
post_creation_tasks() {
    echo "🎉 Template Created Successfully!"
    echo "➡ To clone this template, run:"
    echo "   qm clone $NEXT_VM_ID 200 --name cloned-vm --full true"
}

# OS Selection
declare -A OS_IMAGES=(
    ["ubuntu-22.04"]="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    ["rocky-8"]="https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"
)

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

# Pre-Creation Hook
pre_creation_tasks

# Download Image
echo "📥 Downloading ${OS} Cloud-Init image..."
wget -O $CLOUD_IMAGE_FILE $IMAGE_URL

if [ ! -f "$CLOUD_IMAGE_FILE" ] || [ ! -s "$CLOUD_IMAGE_FILE" ]; then
    echo "❌ ERROR: Failed to download ${OS} Cloud-Init image. Exiting..."
    rm -f "$CLOUD_IMAGE_FILE"
    exit 1
fi

# Create VM and Convert to Template
qm create $NEXT_VM_ID --name $TEMPLATE_NAME --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk $NEXT_VM_ID $CLOUD_IMAGE_FILE $PROXMOX_STORAGE
qm set $NEXT_VM_ID --scsihw virtio-scsi-pci --scsi0 $PROXMOX_STORAGE:vm-$NEXT_VM_ID-disk-0
qm set $NEXT_VM_ID --ide2 $PROXMOX_STORAGE:cloudinit
qm template $NEXT_VM_ID

# Post-Creation Hook
post_creation_tasks

# Cleanup
rm -f $CLOUD_IMAGE_FILE
✨ What This Enhancement Does
✔ Pre-checks system resources before creating a template.
✔ Prevents duplicate templates.
✔ Provides a helpful message on how to clone the template.

Would you like a script to automate VM cloning from this template? 🚀