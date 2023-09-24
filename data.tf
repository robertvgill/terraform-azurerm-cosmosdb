## vnet
data "azurerm_virtual_network" "vnet" {
  count               = var.nosql_cosmosdb_create ? 1 : 0

  name                = format("%s", var.nw_virtual_network_name)
  resource_group_name = var.rg_resource_group_name
}

## subnet
data "azurerm_subnet" "sql" {
  count                = var.nosql_cosmosdb_create ? 1 : 0

  name                 = format("%s", var.nw_vnet_subnet_sql)
  virtual_network_name = var.nw_virtual_network_name
  resource_group_name  = var.rg_resource_group_name
}

## private dns
data "azurerm_private_dns_zone" "nosqldz" {
  count               = var.nosql_cosmosdb_create && var.nosql_does_private_dns_zone_exist ? 1 : 0

  name                = format("%s", lower("privatelink.mongo.cosmos.azure.com"))
  resource_group_name = var.rg_resource_group_name
}

data "azurerm_user_assigned_identity" "cosmosdb_identity" {
  count                = var.nosql_cosmosdb_create ? 1 : 0

  name                 = "cosmosdb-identity"
  resource_group_name  = var.rg_resource_group_name
}