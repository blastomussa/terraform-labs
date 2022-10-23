# Create hub virtual network
resource "azurerm_virtual_network" "hub_network" {
  name                = "hub-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


# Create spoke virtual network
resource "azurerm_virtual_network" "spoke_network1" {
  name                = "spoke1-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


# Create spoke virtual network
resource "azurerm_virtual_network" "spoke_network2" {
  name                = "spoke2-vnet"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


# Create bastion subnet
resource "azurerm_subnet" "bastion" {
  name                 = "bastion-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = ["10.0.1.0/27"] #bastion required to be on /27 subnet 
}


# Create firewall subnet
resource "azurerm_subnet" "firewall" {
  name                 = "firewall-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = ["10.0.2.0/24"]
}


# Create vpn subnet
resource "azurerm_subnet" "vpn" {
  name                 = "vpn-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = ["10.0.3.0/24"]
}


# Create spoke1 subnet
resource "azurerm_subnet" "spoke1" {
  name                 = "spoke1-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_network1.name
  address_prefixes     = ["10.1.1.0/24"]
}


# Create spoke2 subnet
resource "azurerm_subnet" "spoke2" {
  name                 = "spoke2-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke_network2.name
  address_prefixes     = ["10.2.1.0/24"]
}


resource "azurerm_virtual_network_peering" "vnet_peer_spoke1a" {
  name                         = "spoke1-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.spoke_network1.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_network.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "vnet_peer_spoke1b" {
  name                         = "hub-to-spoke1"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub_network.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_network1.name
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "vnet_peer_spoke2a" {
  name                         = "spoke2-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.spoke_network2.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_network.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways
}


resource "azurerm_virtual_network_peering" "vnet_peer_spoke2b" {
  name                         = "hub-to-spoke2"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub_network.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_network2.name
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways
}
