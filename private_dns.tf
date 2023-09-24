## private dns
resource "azurerm_private_dns_zone" "nosqldz" {
  count               = var.nosql_cosmosdb_create && var.nosql_enable_private_endpoint && var.nosql_does_private_dns_zone_exist == false ? 1 : 0

  name                = var.nosql_private_dns_zone_name
  resource_group_name = var.rg_resource_group_name
  tags                = merge({ "ResourceName" = format("%s", lower(var.nosql_private_dns_zone_name)) }, var.tags, )
}

resource "azurerm_private_dns_zone_virtual_network_link" "dzvlink" {
  count                 = var.nosql_cosmosdb_create && var.nosql_enable_private_endpoint && var.nosql_does_private_dns_zone_exist == false ? 1 : 0

  name                  = lower("${var.nw_virtual_network_name}-link")
  resource_group_name   = var.rg_resource_group_name
  virtual_network_id    = data.azurerm_virtual_network.vnet[0].id
  private_dns_zone_name = var.nosql_does_private_dns_zone_exist ? data.azurerm_private_dns_zone.nosqldz[0].name : azurerm_private_dns_zone.nosqldz[0].name
  tags                  = merge({ "ResourceName" = format("%s", lower("${var.nosql_private_dns_zone_name}-link")) }, var.tags, )

  lifecycle {
    ignore_changes = [
      virtual_network_id,
    ]
  }
}