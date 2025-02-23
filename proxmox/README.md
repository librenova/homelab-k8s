## Proxmox Management
Contains scripts and templates for managing Proxmox VMs.
How to Use These Templates in Proxmox
1️⃣ Create a Cloud-Init Ubuntu 22.04 Template in Proxmox

sh
Copy
Edit
qm create 9000 --name ubuntu-22-cloud --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0
2️⃣ Import a Cloud-Init Image

sh
Copy
Edit
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
3️⃣ Enable Cloud-Init Support

sh
Copy
Edit
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot c --bootdisk scsi0
4️⃣ Convert into a Template

sh
Copy
Edit
qm template 9000
5️⃣ Clone VMs from Template

sh
Copy
Edit
qm clone 9000 100 --name k8s-master
qm clone 9000 101 --name k8s-worker-1
6️⃣ Apply Cloud-Init Configuration

sh
Copy
Edit
qm set 100 --cicustom "user=local:snippets/k8s-master-cloud-init.yml"
qm set 101 --cicustom "user=local:snippets/k8s-worker-cloud-init.yml"
7️⃣ Start VMs

sh
Copy
Edit
qm start 100
qm start 101
✅ Result:
Your Kubernetes Master and Worker Nodes will be provisioned with Proxmox Cloud-Init.

Would you like any modifications to the cloud-init templates or help with scaling the cluster? 🚀







You said:
create a script on how to use these templates in proxmox
ChatGPT said:
Here’s a Bash script to automate the entire process of setting up Proxmox Cloud-Init templates for Kubernetes Master and Worker nodes and deploying Kubernetes VMs.