## resource group
variable "rg_resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
  default     = null
}

variable "rg_location" {
  description = "Specifies the supported Azure location where the resource should be created."
  type        = string
  default     = null
}

## virtual network
variable "nw_virtual_network_name" {
  description = "The name of the Virtual Network."
  type        = string
  default     = null
}

variable "nw_vnet_subnet_sql" {
  description = "The name of the subnet for CosmosDB."
  type        = string
}

## cosmosdb
variable "nosql_cosmosdb_create" {
  description = "Controls if CosmosDB should be created."
  type        = bool
  default     = false
}

variable "nosql_cosmosdb_name" {
  description = "The name of the CosmosDB."
  type        = string
  default     = null
}

variable "nosql_cosmosdb_config" {
  description = "Manages a CosmosDB Account configuration."
  type = object({
    offer_type                            = string
    kind                                  = string
    enable_free_tier                      = bool
    analytical_storage_enabled            = bool
    enable_automatic_failover             = bool
    public_network_access_enabled         = bool
    is_virtual_network_filter_enabled     = bool
    key_vault_key_id                      = string
    enable_multiple_write_locations       = bool
    access_key_metadata_writes_enabled    = bool
    mongo_server_version                  = string
    network_acl_bypass_for_azure_services = bool
  })
  default = null
}

variable "nosql_allowed_ip_range_cidrs" {
  description = "CosmosDB Firewall Support: This value specifies the set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account. IP addresses/ranges must be comma separated and must not contain any spaces."
  type        = list(string)
  default     = []
}

variable "nosql_consistency_policy" {
  description = "Consistency levels in Azure CosmosDB."
  type = object({
    consistency_level       = string
    max_interval_in_seconds = number
    max_staleness_prefix    = number
  })
}

variable "nosql_default_failover_locations" {
  type = list(object({
    location = string
  }))
  default     = null
}

variable "nosql_failover_locations" {
  description = "The name of the Azure region to host replicated data and their priority."
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = bool
  }))
  default     = null
}

variable "nosql_capabilities" {
  description = "Configures the capabilities to enable for this CosmosDB account. Possible values are `AllowSelfServeUpgradeToMongo36`, `DisableRateLimitingResponses`, `EnableAggregationPipeline`, `EnableCassandra`, `EnableGremlin`, `EnableMongo`, `EnableTable`, `EnableServerless`, `MongoDBv3.4` and `mongoEnableDocLevelTTL`."
  type        = list(string)
  default     = []
}

variable "nosql_virtual_network_rules" {
  description = "Configures the virtual network subnets allowed to access this CosmosDB account."
  type = list(object({
    id                                   = string
    ignore_missing_vnet_service_endpoint = bool
  }))
  default = null
}

variable "nosql_backup" {
  type        = map(string)
  description = "Specifies the backup setting for different types, intervals and retention time in hours that each backup is retained."
  default = {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
  }
}

variable "nosql_cors_rules" {
  description = "Cross-Origin Resource Sharing (CORS) is an HTTP feature that enables a web application running under one domain to access resources in another domain."
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default     = null
}

variable "nosql_managed_identity" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Cosmos account. Possible value is only SystemAssigned. Defaults to false."
  default     = false
}

variable "nosql_private_dns_zone_name" {
  description = "The name of the Private DNS zone for CosmosDB."
  default     = null
}

variable "nosql_does_private_dns_zone_exist" {
  type        = bool
  default     = false
}

variable "nosql_enable_private_endpoint" {
  description = "Manages a Private Endpoint to Azure CosmosDB account."
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
}