resource "azurerm_log_analytics_workspace" "main" {
  name                = "LAW-Terraform-Enterprise-Lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = azurerm_resource_group.lab.tags
}
resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.application.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}
resource "azurerm_monitor_data_collection_rule" "application" {
  name                = "DCR-AppVM-Linux"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  kind                = "Linux"
  description         = "Collect warning and higher-level Linux syslog events"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "log-analytics-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["log-analytics-destination"]
  }

  data_sources {
    syslog {
      facility_names = ["*"]
      log_levels = [
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency"
      ]
      name    = "linux-syslog"
      streams = ["Microsoft-Syslog"]
    }
  }

  tags = azurerm_resource_group.lab.tags
}

resource "azurerm_monitor_data_collection_rule_association" "application" {
  name                    = "DCRA-AppVM-Linux"
  target_resource_id      = azurerm_linux_virtual_machine.application.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.application.id
  description             = "Associates the Linux application VM with its monitoring rule"

  depends_on = [
    azurerm_virtual_machine_extension.azure_monitor_agent
  ]
}
