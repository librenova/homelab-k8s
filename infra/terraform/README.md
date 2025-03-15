terraform/
│── modules/                           # Reusable Terraform modules
│   ├── proxmox-vm/                    # Proxmox VM provisioning module
│   │   ├── main.tf                     # Proxmox VM resource definition
│   │   ├── variables.tf                 # Input variables for the module
│   │   ├── outputs.tf                   # Outputs for the module
│   │   ├── networkdata.tpl              # Cloud-Init networking template
│   │   ├── inventory.tpl                 # Ansible inventory template
│   │   ├── README.md                     # Documentation for the module
│   ├── networking/                      # Networking module (VLANs, Firewalls)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── storage/                         # Storage module (Persistent Volumes, S3, Azure Blob)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│── environments/                         # Environment-specific configurations
│   ├── dev/                              # Dev environment
│   │   ├── main.tf                        # Calls modules for Dev
│   │   ├── terraform.tfvars               # Variables for Dev
│   ├── prod/                             # Prod environment
│   │   ├── main.tf                        # Calls modules for Prod
│   │   ├── terraform.tfvars               # Variables for Prod
│── snippets/                             # Cloud-Init configuration files
│   ├── master-networkdata.yml
│   ├── worker-1-networkdata.yml
│   ├── worker-2-networkdata.yml
│   ├── worker-3-networkdata.yml
│── backend.tf                            # Remote state configuration
│── main.tf                               # Entry point for Terraform execution
│── variables.tf                          # Common Terraform variables
│── outputs.tf                            # Common Terraform outputs
│── providers.tf                          # Terraform provider configurations
│── README.md                             # Documentation for Terraform setup



What Happens When You Execute the Terraform Initialization & Apply Commands?
When you execute the Terraform commands in the Kubernetes cluster environment (dev-k8s-cluster1), the following things will happen based on your folder structure and Terraform configuration:

✅ Step-by-Step Execution Breakdown
Assuming you have correctly structured the Terraform files, here’s what happens:

1️⃣ Run terraform init -upgrade
sh
Copy
Edit
terraform init -upgrade
✔ What it does:

Initializes Terraform in the /environments/dev/k8s-cluster/dev-k8s-cluster1/ folder.
Downloads all providers (e.g., telmate/proxmox, kubernetes).
Pulls module dependencies (e.g., modules/proxmox-vm, modules/kubernetes).
Configures backend state storage if backend.tf is defined.
✔ What does NOT happen:

No actual resources (VMs, K8s clusters) are created yet.
2️⃣ Run terraform validate
sh
Copy
Edit
terraform validate
✔ What it does:

Checks if the Terraform syntax is correct.
Ensures that required variables and modules are properly referenced.
No changes are applied yet.
3️⃣ Run terraform plan
sh
Copy
Edit
terraform plan
✔ What it does:

Generates an execution plan without making any changes.
Shows what resources will be created, updated, or destroyed.
Helps identify any missing variables or provider issues.
4️⃣ Run terraform apply -auto-approve
sh
Copy
Edit
terraform apply -auto-approve
✔ What happens when this runs?

Proxmox VM Templates (Ubuntu) Get Created

If main.tf inside /environments/dev/template-setup/ubuntu/ references the modules/proxmox-vm-template, Terraform will:
Create Proxmox Cloud-Init templates for Kubernetes.
Store these templates in Proxmox for VM cloning.
Kubernetes Cluster (k8s-cluster1) VMs Get Created

If main.tf inside /environments/dev/k8s-cluster/dev-k8s-cluster1/ references modules/proxmox-vm, Terraform will:
Deploy Kubernetes master and worker nodes in Proxmox.
Assign networking and IP addresses based on the modules/networking configuration.
Networking & Load Balancers Get Configured

If modules/networking/main.tf is included, Terraform will:
Create Proxmox virtual bridges (vmbr) or VLANs.
Set up public/private networking for Kubernetes nodes.
Kubernetes Cluster Gets Configured

If modules/kubernetes/main.tf is executed, Terraform will:
Initialize the Kubernetes control plane.
Join worker nodes to the cluster.
Deploy Kubelet, API Server, and necessary K8s components.
✔ Final Expected Outcome: ✅ Proxmox VM templates are created.
✅ Kubernetes master and worker VMs are provisioned.
✅ Networking and security groups are applied.
✅ Kubernetes cluster is set up inside the Proxmox environment.

📌 What If I Only Want to Create Proxmox Templates First?
If you only want to create Proxmox templates, navigate to the template setup directory and apply only that module:

sh
Copy
Edit
cd /opt/vscode/homelab-k8s/infra/terraform/environments/dev/template-setup/ubuntu
terraform init -upgrade
terraform apply -auto-approve
✔ This will ONLY create Ubuntu Cloud-Init templates in Proxmox.

📌 How Can I Verify That Kubernetes Was Successfully Created?
After the Terraform run: 1️⃣ Check Proxmox UI

Log in to Proxmox (https://192.168.4.54:8006/).
Verify that the Kubernetes master and worker VMs are running.
2️⃣ SSH into the Kubernetes Master Node

sh
Copy
Edit
ssh root@<master-node-ip>
kubectl get nodes
✔ Expected Output:

pgsql
Copy
Edit
NAME           STATUS    ROLES    AGE     VERSION
master-1       Ready     master   10m     v1.28.0
worker-1       Ready     <none>   9m      v1.28.0
worker-2       Ready     <none>   9m      v1.28.0
✔ If nodes show "Ready", Kubernetes is successfully running.

📌 Summary
✅ Running terraform apply will automatically create the Proxmox templates & Kubernetes cluster.
✅ If the full environment is applied, Terraform will:

Create Proxmox VM templates.
Deploy Kubernetes cluster inside Proxmox.
Configure networking & firewall rules.
✅ If you only want to create Proxmox templates first, apply only the template-setup directory.
🚀 Next Steps
Would you like: ✅ A Terraform automation script to simplify this workflow?
✅ A CI/CD pipeline to automate Terraform in GitHub/GitLab? 🚀





📌 Summary: Terraform Step-by-Step Execution
Step	Command to Run	What Happens?
1️⃣ Create Proxmox Templates	cd environments/dev/template-setup/ubuntu && terraform apply -auto-approve	Creates Ubuntu Cloud-Init templates
2️⃣ Create Kubernetes VMs	cd environments/dev/k8s-cluster/dev-k8s-cluster1 && terraform apply -auto-approve	Deploys Kubernetes master & workers
3️⃣ Configure Networking	cd modules/networking && terraform apply -auto-approve	Sets up virtual bridges/VLANs
4️⃣ Initialize Kubernetes	cd modules/kubernetes && terraform apply -auto-approve	Installs Kubernetes & joins nodes






