#!/bin/bash

# Define the root directory for the Git repository
ROOT_DIR="homelab-gitlab"

# Define all required folders
declare -a FOLDERS=(
    "$ROOT_DIR/ansible/playbooks"
    "$ROOT_DIR/apps/frontend"
    "$ROOT_DIR/apps/backend"
    "$ROOT_DIR/ci-cd/github-actions"
    "$ROOT_DIR/ci-cd/gitlab-ci"
    "$ROOT_DIR/docs"
    "$ROOT_DIR/gitops/flux"
    "$ROOT_DIR/helm/charts"
    "$ROOT_DIR/k8s/manifests"
    "$ROOT_DIR/monitoring/prometheus"
    "$ROOT_DIR/monitoring/grafana"
    "$ROOT_DIR/proxmox/terraform"
    "$ROOT_DIR/scripts"
    "$ROOT_DIR/security/terraform"
    "$ROOT_DIR/security/ansible"
    "$ROOT_DIR/security/policies"
    "$ROOT_DIR/terraform/modules/proxmox-vm"
    "$ROOT_DIR/terraform/modules/networking"
    "$ROOT_DIR/test/unit"
    "$ROOT_DIR/test/integration"
    "$ROOT_DIR/backup"
)

# Create folders
for folder in "${FOLDERS[@]}"; do
    mkdir -p "$folder"
done

# Create README files for each major section
echo "# 🚀 Infrastructure as Code (IaC) for Proxmox & Kubernetes" > "$ROOT_DIR/README.md"
echo "# 🔧 Ansible Playbooks for Automation" > "$ROOT_DIR/ansible/README.md"
echo "# 🏗️ Applications (Frontend & Backend)" > "$ROOT_DIR/apps/README.md"
echo "# ⚡ CI/CD Pipelines for Automated Deployments" > "$ROOT_DIR/ci-cd/README.md"
echo "# 📖 Documentation and Guidelines" > "$ROOT_DIR/docs/README.md"
echo "# 🌎 GitOps Workflow with FluxCD" > "$ROOT_DIR/gitops/README.md"
echo "# ⎈ Helm Charts for Kubernetes" > "$ROOT_DIR/helm/README.md"
echo "# 🔍 Kubernetes Manifests" > "$ROOT_DIR/k8s/README.md"
echo "# 📊 Monitoring with Prometheus & Grafana" > "$ROOT_DIR/monitoring/README.md"
echo "# 📦 Proxmox Infrastructure Automation" > "$ROOT_DIR/proxmox/README.md"
echo "# 🔐 Security Configurations & Hardening" > "$ROOT_DIR/security/README.md"
echo "# 📝 Terraform Infrastructure Provisioning" > "$ROOT_DIR/terraform/README.md"
echo "# 🧪 Automated Testing Suite" > "$ROOT_DIR/test/README.md"
echo "# 💾 Backup and Recovery Strategies" > "$ROOT_DIR/backup/README.md"

# Create Terraform files with complete content
cat <<EOF > "$ROOT_DIR/terraform/modules/proxmox-vm/main.tf"
provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_user    = var.proxmox_user
  pm_password = var.proxmox_password
}

resource "proxmox_vm_qemu" "vm" {
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
}
EOF

cat <<EOF > "$ROOT_DIR/terraform/modules/proxmox-vm/variables.tf"
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

# Create Ansible playbooks with complete content
cat <<EOF > "$ROOT_DIR/ansible/playbooks/k8s-setup.yml"
- name: Setup Kubernetes Nodes
  hosts: all
  become: yes
  tasks:
    - name: Install required packages
      apt:
        name: ['docker.io', 'kubelet', 'kubeadm', 'kubectl']
        state: present
EOF

# Create Kubernetes manifests with complete content
cat <<EOF > "$ROOT_DIR/k8s/manifests/nginx-deployment.yml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
EOF

# Create GitOps FluxCD configuration with complete content
cat <<EOF > "$ROOT_DIR/gitops/flux/source.yml"
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 5m
  url: https://github.com/your-repo/homelab-gitops.git
  ref:
    branch: main
EOF

# Create Helm chart with complete content
cat <<EOF > "$ROOT_DIR/helm/charts/Chart.yaml"
apiVersion: v2
name: my-chart
description: A Helm chart for Kubernetes
version: 0.1.0
EOF

# Create monitoring configurations
cat <<EOF > "$ROOT_DIR/monitoring/prometheus/prometheus.yml"
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'kubernetes-nodes'
    static_configs:
      - targets: ['localhost:9100']
EOF

# Create CI/CD configuration with complete content
cat <<EOF > "$ROOT_DIR/ci-cd/github-actions/workflow.yml"
name: CI Pipeline
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Run tests
        run: echo 'Running tests...'
EOF

# Create a simple deploy script
cat <<EOF > "$ROOT_DIR/scripts/deploy.sh"
#!/bin/bash
echo 'Deploying infrastructure...'
EOF
chmod +x "$ROOT_DIR/scripts/deploy.sh"

# Create a backup script
cat <<EOF > "$ROOT_DIR/backup/backup.sh"
#!/bin/bash
echo 'Running backup...'
EOF
chmod +x "$ROOT_DIR/backup/backup.sh"

# Initialize Git repository
cd "$ROOT_DIR"
git init
git add .
git commit -m "Initial commit: Setup Git project structure with required files"

echo "✅ Git project structure and required files created successfully."
