#!/bin/bash

# Define the root Terraform directory
TERRAFORM_DIR="terraform"

# Define all required subdirectories
declare -a FOLDERS=(
    "$TERRAFORM_DIR/modules/networking"
    "$TERRAFORM_DIR/modules/storage"
    "$TERRAFORM_DIR/modules/proxmox-vm"
    "$TERRAFORM_DIR/modules/aws-eks"
    "$TERRAFORM_DIR/modules/azure-aks"
    "$TERRAFORM_DIR/environments/dev"
    "$TERRAFORM_DIR/environments/prod"
)

# Create folders
for folder in "${FOLDERS[@]}"; do
    mkdir -p "$folder"
done

# Create README files for each major section
echo "# 🌍 Terraform Infrastructure Modules" > "$TERRAFORM_DIR/modules/README.md"
echo "# 📂 Terraform Environments" > "$TERRAFORM_DIR/environments/README.md"

# --- Sample Terraform Backend Configuration ---
cat <<EOF > "$TERRAFORM_DIR/backend.tf"
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
EOF

# --- Sample Terraform Providers Configuration ---
cat <<EOF > "$TERRAFORM_DIR/providers.tf"
provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}
EOF

# --- Sample Terraform Variables Configuration ---
cat <<EOF > "$TERRAFORM_DIR/variables.tf"
variable "proxmox_api_url" { type = string }
variable "proxmox_user" { type = string }
variable "proxmox_password" { type = string }
variable "aws_region" { type = string }
variable "azure_location" { type = string }
variable "network_cidr" { type = string }
EOF

# --- Sample Terraform Outputs Configuration ---
cat <<EOF > "$TERRAFORM_DIR/outputs.tf"
output "aws_vpc_id" {
  value = module.networking.aws_vpc_id
}

output "azure_vnet_id" {
  value = module.networking.azure_vnet_id
}

output "proxmox_vm_ids" {
  value = module.proxmox-vm.vm_ids
}
EOF

# --- Sample Main Terraform File ---
cat <<EOF > "$TERRAFORM_DIR/main.tf"
module "networking" {
  source         = "./modules/networking"
  network_cidr  = var.network_cidr
}

module "storage" {
  source       = "./modules/storage"
}

module "proxmox-vm" {
  source       = "./modules/proxmox-vm"
  proxmox_api_url = var.proxmox_api_url
}

module "aws-eks" {
  source = "./modules/aws-eks"
  aws_region = var.aws_region
}

module "azure-aks" {
  source = "./modules/azure-aks"
  azure_location = var.azure_location
}
EOF

# --- Sample Networking Module ---
cat <<EOF > "$TERRAFORM_DIR/modules/networking/main.tf"
resource "aws_vpc" "main" {
  cidr_block = var.network_cidr
}

resource "azurerm_virtual_network" "main" {
  name                = "main-vnet"
  location            = var.azure_location
  resource_group_name = "terraform-rg"
  address_space       = [var.network_cidr]
}
EOF

cat <<EOF > "$TERRAFORM_DIR/modules/networking/variables.tf"
variable "network_cidr" { type = string }
variable "azure_location" { type = string }
EOF

cat <<EOF > "$TERRAFORM_DIR/modules/networking/outputs.tf"
output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "azure_vnet_id" {
  value = azurerm_virtual_network.main.id
}
EOF

# --- Sample Storage Module ---
cat <<EOF > "$TERRAFORM_DIR/modules/storage/main.tf"
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-backend"
  acl    = "private"
}

resource "azurerm_storage_account" "storage" {
  name                     = "terraformstorage"
  resource_group_name      = "terraform-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
EOF

# --- Sample Proxmox VM Module ---
cat <<EOF > "$TERRAFORM_DIR/modules/proxmox-vm/main.tf"
resource "proxmox_vm_qemu" "vm" {
  name        = "terraform-proxmox-vm"
  target_node = "pve"
  clone       = "ubuntu-template"
  cores       = 2
  memory      = 4096

  disk {
    size    = "50G"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
}
EOF

# --- Sample AWS EKS Module ---
cat <<EOF > "$TERRAFORM_DIR/modules/aws-eks/main.tf"
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.27"
  subnets         = module.networking.aws_vpc_id
  vpc_id          = module.networking.aws_vpc_id
}
EOF

# --- Sample Azure AKS Module ---
cat <<EOF > "$TERRAFORM_DIR/modules/azure-aks/main.tf"
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = var.azure_location
  resource_group_name = "terraform-rg"
  dns_prefix          = "terraformaks"
}
EOF

# --- Sample Dev Environment Configuration ---
cat <<EOF > "$TERRAFORM_DIR/environments/dev/main.tf"
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

module "networking" {
  source       = "../../modules/networking"
  network_cidr = "10.0.0.0/16"
}
EOF

# --- Sample Prod Environment Configuration ---
cat <<EOF > "$TERRAFORM_DIR/environments/prod/main.tf"
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

module "networking" {
  source       = "../../modules/networking"
  network_cidr = "192.168.0.0/16"
}
EOF

echo "✅ Terraform folder structure and sample files created successfully."
