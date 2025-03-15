#!/bin/bash

# Define the root Cloud directory
CLOUD_DIR="cloud"

# Define all required subdirectories
declare -a FOLDERS=(
    "$CLOUD_DIR/aws/eks"
    "$CLOUD_DIR/aws/networking"
    "$CLOUD_DIR/aws/storage"
    "$CLOUD_DIR/aws/services"
    "$CLOUD_DIR/azure/aks"
    "$CLOUD_DIR/azure/networking"
    "$CLOUD_DIR/azure/storage"
    "$CLOUD_DIR/azure/services"
    "$CLOUD_DIR/multi-cloud/networking"
    "$CLOUD_DIR/multi-cloud/storage"
    "$CLOUD_DIR/multi-cloud/security"
    "$CLOUD_DIR/multi-cloud/disaster-recovery"
)

# Create folders
for folder in "${FOLDERS[@]}"; do
    mkdir -p "$folder"
done

# Create README files for each major section
echo "# ☁️ AWS Infrastructure" > "$CLOUD_DIR/aws/README.md"
echo "# ☁️ Azure Infrastructure" > "$CLOUD_DIR/azure/README.md"
echo "# ☁️ Multi-Cloud Configurations" > "$CLOUD_DIR/multi-cloud/README.md"

# --- Sample AWS EKS Cluster Terraform ---
cat <<EOF > "$CLOUD_DIR/aws/eks/main.tf"
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "aws-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.subnet_ids
}
EOF

# --- Sample AWS Networking Terraform ---
cat <<EOF > "$CLOUD_DIR/aws/networking/main.tf"
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}
EOF

# --- Sample AWS Storage Terraform ---
cat <<EOF > "$CLOUD_DIR/aws/storage/main.tf"
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
  acl    = "private"
}

resource "aws_ebs_volume" "storage" {
  availability_zone = "us-east-1a"
  size             = 100
}
EOF

# --- Sample AWS Services Terraform ---
cat <<EOF > "$CLOUD_DIR/aws/services/main.tf"
resource "aws_rds_instance" "database" {
  allocated_storage = 20
  engine           = "mysql"
  instance_class   = "db.t3.micro"
  username        = "admin"
  password        = "securepassword"
}
EOF

# --- Sample Azure AKS Cluster Terraform ---
cat <<EOF > "$CLOUD_DIR/azure/aks/main.tf"
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "azure-aks-cluster"
  location            = "East US"
  resource_group_name = "azure-rg"
  dns_prefix          = "azureaks"
}
EOF

# --- Sample Azure Networking Terraform ---
cat <<EOF > "$CLOUD_DIR/azure/networking/main.tf"
resource "azurerm_virtual_network" "vnet" {
  name                = "azure-vnet"
  location            = "East US"
  resource_group_name = "azure-rg"
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "azure-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = "azure-rg"
  address_prefixes     = ["10.1.1.0/24"]
}
EOF

# --- Sample Azure Storage Terraform ---
cat <<EOF > "$CLOUD_DIR/azure/storage/main.tf"
resource "azurerm_storage_account" "storage" {
  name                     = "azurestoragetf"
  resource_group_name      = "azure-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
EOF

# --- Sample Azure Services Terraform ---
cat <<EOF > "$CLOUD_DIR/azure/services/main.tf"
resource "azurerm_mssql_server" "database" {
  name                         = "azure-sql-server"
  resource_group_name          = "azure-rg"
  location                     = "East US"
  version                      = "12.0"
  administrator_login          = "admin"
  administrator_login_password = "securepassword"
}
EOF

# --- Sample Multi-Cloud Networking Terraform ---
cat <<EOF > "$CLOUD_DIR/multi-cloud/networking/main.tf"
resource "aws_vpc_peering_connection" "multi_cloud" {
  vpc_id      = aws_vpc.main.id
  peer_vpc_id = azurerm_virtual_network.vnet.id
  auto_accept = true
}
EOF

# --- Sample Multi-Cloud Storage Terraform ---
cat <<EOF > "$CLOUD_DIR/multi-cloud/storage/main.tf"
resource "aws_s3_bucket" "multi_cloud_backup" {
  bucket = "multi-cloud-backup"
  acl    = "private"
}

resource "azurerm_storage_account" "dr_backup" {
  name                     = "drbackupstorage"
  resource_group_name      = "azure-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
EOF

# --- Sample Multi-Cloud Security Terraform ---
cat <<EOF > "$CLOUD_DIR/multi-cloud/security/main.tf"
resource "aws_iam_role" "azure_ad_federation" {
  name = "AzureADFederationRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::AWS_ACCOUNT_ID:saml-provider/AzureAD" },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": { "StringEquals": { "SAML:aud": "https://signin.aws.amazon.com/saml" } }
    }
  ]
}
POLICY
}
EOF

# --- Sample Multi-Cloud Disaster Recovery Terraform ---
cat <<EOF > "$CLOUD_DIR/multi-cloud/disaster-recovery/main.tf"
resource "aws_route53_health_check" "azure_backup" {
  fqdn              = "azure-backup-service.example.com"
  port              = 443
  type              = "HTTPS"
  failure_threshold = 3
  request_interval  = 30
}

resource "azurerm_traffic_manager_profile" "aws_failover" {
  name                = "aws-failover"
  resource_group_name = "azure-rg"
  traffic_routing_method = "Priority"
}
EOF

echo "✅ Cloud folder structure and sample files created successfully."
