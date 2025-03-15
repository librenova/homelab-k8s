#!/bin/bash

# Define the base directory
BASE_DIR="homelab-gitlab"

# Define the folder structure with README content
declare -A FOLDERS

FOLDERS["$BASE_DIR/terraform"]="## Terraform\nThis directory contains infrastructure-as-code (IaC) configurations using Terraform to provision and manage on-prem and cloud resources."
FOLDERS["$BASE_DIR/terraform/modules/proxmox"]="## Terraform Proxmox Module\nContains reusable Terraform configurations for provisioning VMs and storage in Proxmox."
FOLDERS["$BASE_DIR/terraform/modules/networking"]="## Terraform Networking Module\nDefines VLANs, Load Balancers, and MetalLB configurations for Kubernetes networking."
FOLDERS["$BASE_DIR/terraform/environments/dev"]="## Terraform Dev Environment\nEnvironment-specific Terraform configurations for the development Kubernetes cluster."
FOLDERS["$BASE_DIR/terraform/environments/staging"]="## Terraform Staging Environment\nContains Terraform configurations for staging Kubernetes clusters."
FOLDERS["$BASE_DIR/terraform/environments/prod"]="## Terraform Production Environment\nTerraform scripts for deploying production-ready Kubernetes clusters."

FOLDERS["$BASE_DIR/ansible"]="## Ansible\nThis directory contains automation scripts to configure on-prem Kubernetes clusters and associated infrastructure."
FOLDERS["$BASE_DIR/ansible/playbooks"]="## Ansible Playbooks\nContains playbooks to automate the installation and configuration of Kubernetes nodes, security hardening, and monitoring."
FOLDERS["$BASE_DIR/ansible/roles/k8s"]="## Kubernetes Role\nDefines Ansible roles for installing Kubernetes components (kubelet, kubeadm, kubectl)."
FOLDERS["$BASE_DIR/ansible/roles/storage"]="## Storage Role\nManages storage provisioning (NFS, Ceph, Longhorn) for Kubernetes clusters."
FOLDERS["$BASE_DIR/ansible/roles/monitoring"]="## Monitoring Role\nAutomates deployment of Prometheus, Grafana, and other observability tools."
FOLDERS["$BASE_DIR/ansible/inventory"]="## Ansible Inventory\nContains the list of hosts managed by Ansible, divided into groups like `master` and `workers`."

FOLDERS["$BASE_DIR/k8s"]="## Kubernetes Manifests\nStores Kubernetes configurations for on-premise clusters."
FOLDERS["$BASE_DIR/k8s/clusters/proxmox"]="## Kubernetes on Proxmox\nContains manifests to deploy a Kubernetes cluster using Proxmox VMs."
FOLDERS["$BASE_DIR/k8s/clusters/baremetal"]="## Kubernetes on Bare Metal\nContains manifests for setting up a bare-metal Kubernetes cluster."
FOLDERS["$BASE_DIR/k8s/storage"]="## Kubernetes Storage Configurations\nDefines PersistentVolume and StorageClass configurations for storage solutions like NFS and Ceph."
FOLDERS["$BASE_DIR/k8s/networking"]="## Kubernetes Networking Configurations\nIncludes manifests for setting up CNI plugins (Calico, Cilium), MetalLB, and Ingress controllers."
FOLDERS["$BASE_DIR/k8s/security"]="## Kubernetes Security Policies\nManages security settings such as RBAC, Pod Security Policies, and Open Policy Agent configurations."

FOLDERS["$BASE_DIR/helm"]="## Helm Charts\nContains Helm charts for deploying applications onto Kubernetes."
FOLDERS["$BASE_DIR/helm/charts/spark"]="## Spark Helm Chart\nHelm chart to deploy Apache Spark on Kubernetes."
FOLDERS["$BASE_DIR/helm/charts/postgres"]="## PostgreSQL Helm Chart\nHelm chart to deploy PostgreSQL databases."
FOLDERS["$BASE_DIR/helm/charts/flink"]="## Flink Helm Chart\nHelm chart to deploy Apache Flink on Kubernetes."
FOLDERS["$BASE_DIR/helm/charts/metastore"]="## Metastore Helm Chart\nHelm chart for managing metadata services."
FOLDERS["$BASE_DIR/helm/values"]="## Helm Values\nContains values files for customizing Helm chart deployments."

FOLDERS["$BASE_DIR/gitops"]="## GitOps Configuration\nAutomates deployments using FluxCD or ArgoCD."
FOLDERS["$BASE_DIR/gitops/clusters/proxmox"]="## GitOps for Proxmox\nContains GitOps configurations for Kubernetes clusters deployed on Proxmox."
FOLDERS["$BASE_DIR/gitops/clusters/baremetal"]="## GitOps for Bare Metal\nContains GitOps configurations for bare-metal Kubernetes clusters."
FOLDERS["$BASE_DIR/gitops/apps"]="## GitOps Application Deployment\nManages application deployments using FluxCD or ArgoCD."

FOLDERS["$BASE_DIR/proxmox"]="## Proxmox Management\nContains scripts and templates for managing Proxmox VMs."
FOLDERS["$BASE_DIR/proxmox/templates"]="## Proxmox VM Templates\nIncludes VM templates for Kubernetes master and worker nodes."
FOLDERS["$BASE_DIR/proxmox/scripts"]="## Proxmox Scripts\nScripts for VM backup, migration, and snapshot management."

FOLDERS["$BASE_DIR/apps"]="## Applications\nContains source code for Spark, PostgreSQL, Flink, APIs, and UI components."
FOLDERS["$BASE_DIR/apps/spark"]="## Spark Application\nSource code and Dockerfiles for Apache Spark."
FOLDERS["$BASE_DIR/apps/postgres"]="## PostgreSQL Application\nSource code and configuration files for PostgreSQL."
FOLDERS["$BASE_DIR/apps/flink"]="## Flink Application\nSource code for Apache Flink processing jobs."
FOLDERS["$BASE_DIR/apps/api"]="## API Services\nBackend services implemented in Python, Node.js, or other frameworks."
FOLDERS["$BASE_DIR/apps/react-app"]="## React Frontend\nFrontend application built using React."
FOLDERS["$BASE_DIR/apps/metastore"]="## Metadata Store\nService for managing metadata of various components."

FOLDERS["$BASE_DIR/ci-cd"]="## CI/CD Pipelines\nGitLab CI/CD pipeline configurations for automated deployments."
FOLDERS["$BASE_DIR/monitoring"]="## Monitoring & Logging\nConfigurations for Prometheus, Grafana, Loki, and other observability tools."
FOLDERS["$BASE_DIR/security"]="## Security Policies\nManages RBAC, firewall rules, and Open Policy Agent configurations."
FOLDERS["$BASE_DIR/scripts"]="## Utility Scripts\nContains various shell scripts for automation."
FOLDERS["$BASE_DIR/docs"]="## Documentation\nSetup guides, architecture diagrams, and troubleshooting documentation."
FOLDERS["$BASE_DIR/tests"]="## Testing Framework\nAutomated test scripts for infrastructure and applications."

# Create folders and README files
for folder in "${!FOLDERS[@]}"; do
  mkdir -p "$folder"
  echo -e "${FOLDERS[$folder]}" > "$folder/README.md"
done

# Print success message
echo "✅ Folder structure with README files created successfully!"
