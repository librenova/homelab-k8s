# Backup strategy between AWS & Azure
resource "aws_s3_bucket" "disaster_recovery" {
  bucket = "multi-cloud-dr-backup"
  acl    = "private"
}

resource "azurerm_storage_account" "dr_backup" {
  name                     = "drbackupstorage"
  resource_group_name      = "multi-cloud-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
