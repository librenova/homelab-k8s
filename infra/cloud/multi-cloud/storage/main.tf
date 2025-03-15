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
