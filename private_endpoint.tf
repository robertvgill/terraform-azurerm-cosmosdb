resource "azurerm_private_endpoint" "nosqlpep" {
  count               = var.nosql_cosmosdb_create ? 1 : 0

  depends_on = [
    azurerm_cosmosdb_account.nosql,
  ]

  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location

  name                = format("%s-private-endpoint", azurerm_cosmosdb_account.nosql[0].name)
  subnet_id           = data.azurerm_subnet.sql[0].id

  private_service_connection {
    name                           = format("%s-private-endpoint", azurerm_cosmosdb_account.nosql[0].name)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cosmosdb_account.nosql[0].id
    subresource_names              = ["MongoDB"]
  }

  private_dns_zone_group {
    name                 = format("%s", azurerm_cosmosdb_account.nosql[0].name)
    private_dns_zone_ids = [azurerm_private_dns_zone.nosqldz[0].id]
  }

  tags     = merge({ "ResourceName" = format("%s-private-endpoint", azurerm_cosmosdb_account.nosql[0].name) }, var.tags, )
}
