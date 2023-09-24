resource "azurerm_cosmosdb_account" "nosql" {
  count               = var.nosql_cosmosdb_create ? 1 : 0

  name                = format("%s", var.nosql_cosmosdb_name)
  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location
  offer_type          = var.nosql_cosmosdb_config.offer_type
  kind                = var.nosql_cosmosdb_config.kind
  ip_range_filter     = join(",", var.nosql_allowed_ip_range_cidrs)
  enable_free_tier                      = var.nosql_cosmosdb_config.enable_free_tier
  analytical_storage_enabled            = var.nosql_cosmosdb_config.analytical_storage_enabled
  enable_automatic_failover             = var.nosql_cosmosdb_config.enable_automatic_failover
  public_network_access_enabled         = var.nosql_cosmosdb_config.public_network_access_enabled
  is_virtual_network_filter_enabled     = var.nosql_cosmosdb_config.is_virtual_network_filter_enabled
  key_vault_key_id                      = var.nosql_cosmosdb_config.key_vault_key_id
  enable_multiple_write_locations       = var.nosql_cosmosdb_config.enable_multiple_write_locations
  access_key_metadata_writes_enabled    = var.nosql_cosmosdb_config.access_key_metadata_writes_enabled
  mongo_server_version                  = var.nosql_cosmosdb_config.mongo_server_version
  network_acl_bypass_for_azure_services = var.nosql_cosmosdb_config.network_acl_bypass_for_azure_services
  tags                                  = merge({ "ResourceName" = format("%s", var.nosql_cosmosdb_name) }, var.tags, )

  consistency_policy {
    consistency_level       = lookup(var.nosql_consistency_policy, "consistency_level", "BoundedStaleness")
    max_interval_in_seconds = lookup(var.nosql_consistency_policy, "consistency_level") == "BoundedStaleness" ? lookup(var.nosql_consistency_policy, "max_interval_in_seconds", 5) : null
    max_staleness_prefix    = lookup(var.nosql_consistency_policy, "consistency_level") == "BoundedStaleness" ? lookup(var.nosql_consistency_policy, "max_staleness_prefix", 100) : null
  }

  dynamic "geo_location" {
    for_each = var.nosql_failover_locations == null ? var.nosql_default_failover_locations : var.nosql_failover_locations
    content {
      location          = geo_location.value.location
      failover_priority = lookup(geo_location.value, "failover_priority", 0)
      zone_redundant    = lookup(geo_location.value, "zone_redundant", false)
    }
  }

  dynamic "capabilities" {
    for_each = toset(var.nosql_capabilities)
    content {
      name = capabilities.key
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.nosql_virtual_network_rules != null ? toset(var.nosql_virtual_network_rules) : []
    content {
      id                                   = virtual_network_rules.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rules.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "backup" {
    for_each = var.nosql_backup != null ? [var.nosql_backup] : []
    content {
      type                = lookup(var.nosql_backup, "type", null)
      interval_in_minutes = lookup(var.nosql_backup, "interval_in_minutes", null)
      retention_in_hours  = lookup(var.nosql_backup, "retention_in_hours", null)
    }
  }

  dynamic "cors_rule" {
    for_each = var.nosql_cors_rules != null ? [var.nosql_cors_rules] : []
    content {
      allowed_headers    = var.nosql_cors_rules.allowed_headers
      allowed_methods    = var.nosql_cors_rules.allowed_methods
      allowed_origins    = var.nosql_cors_rules.allowed_origins
      exposed_headers    = var.nosql_cors_rules.exposed_headers
      max_age_in_seconds = var.nosql_cors_rules.max_age_in_seconds
    }
  }

  dynamic "identity" {
    for_each = var.nosql_managed_identity == true ? [1] : [0]
    content {
      type = "SystemAssigned"
    }
  }

  lifecycle {
    ignore_changes = [
      ip_range_filter,
      tags,
    ]
  }
}