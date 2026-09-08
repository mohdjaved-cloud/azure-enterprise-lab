output "application_public_ip" {
  description = "Public IP address of the application VM"
  value       = azurerm_public_ip.application.ip_address
}

output "application_private_ip" {
  description = "Private IP address of the application VM"
  value       = azurerm_network_interface.application.private_ip_address
}

output "application_url" {
  description = "URL of the NGINX application"
  value       = format("http://%s", azurerm_public_ip.application.ip_address)
}