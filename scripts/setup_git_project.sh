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

# Create required Terraform files (without content)
touch "$ROOT_DIR/terraform/modules/proxmox-vm/main.tf"
touch "$ROOT_DIR/terraform/modules/proxmox-vm/variables.tf"
touch "$ROOT_DIR/terraform/modules/proxmox-vm/outputs.tf"
touch "$ROOT_DIR/terraform/modules/networking/main.tf"
touch "$ROOT_DIR/terraform/modules/networking/variables.tf"
touch "$ROOT_DIR/terraform/modules/networking/outputs.tf"
touch "$ROOT_DIR/terraform/environments/dev/backend.tf"
touch "$ROOT_DIR/terraform/environments/dev/main.tf"
touch "$ROOT_DIR/terraform/environments/dev/terraform.tfvars"

# Create required Security Terraform configurations
touch "$ROOT_DIR/security/terraform/firewall-rules.tf"
touch "$ROOT_DIR/security/terraform/access-control.tf"
touch "$ROOT_DIR/security/terraform/ssh-keys.tf"

# Create required Ansible playbooks (without content)
touch "$ROOT_DIR/ansible/playbooks/k8s-setup.yml"
touch "$ROOT_DIR/security/ansible/security.yml"

# Create required Kubernetes manifest files (without content)
touch "$ROOT_DIR/k8s/manifests/nginx-deployment.yml"

# Create required GitOps FluxCD configuration (without content)
touch "$ROOT_DIR/gitops/flux/source.yml"

# Create required Helm chart files (without content)
touch "$ROOT_DIR/helm/charts/Chart.yaml"

# Create required CI/CD files (without content)
touch "$ROOT_DIR/ci-cd/github-actions/workflow.yml"
touch "$ROOT_DIR/ci-cd/gitlab-ci/.gitlab-ci.yml"

# Create required monitoring configurations (without content)
touch "$ROOT_DIR/monitoring/prometheus/prometheus.yml"
touch "$ROOT_DIR/monitoring/grafana/dashboards.yml"

# Create required scripts (without content)
touch "$ROOT_DIR/scripts/deploy.sh"
chmod +x "$ROOT_DIR/scripts/deploy.sh"

# Create required testing files (without content)
touch "$ROOT_DIR/test/unit/sample-test.js"
touch "$ROOT_DIR/test/integration/sample-test.js"

# Create required backup script (without content)
touch "$ROOT_DIR/backup/backup.sh"
chmod +x "$ROOT_DIR/backup/backup.sh"

# Initialize Git repository
cd "$ROOT_DIR"
git init
git add .
git commit -m "Initial commit: Setup Git project structure with required files"

echo "✅ Git project structure and required files created successfully."
