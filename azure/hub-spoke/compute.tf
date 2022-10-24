resource "random_integer" "ri" {
  min = 100
  max = 999
}

module "linuxservers1" {
  source                           = "Azure/compute/azurerm"
  resource_group_name              = azurerm_resource_group.rg.name
  vm_hostname                      = "linuxvm-${count.index}"
  nb_public_ip                     = 0
  nb_instances = 2
  remote_port                      = "22"
  vm_os_publisher                  = "Canonical"
  vm_os_offer                      = "UbuntuServer"
  vm_os_sku                        = "18.04-LTS"
  vnet_subnet_id                   = azurerm_subnet.spoke1.id
  boot_diagnostics                 = false
  delete_os_disk_on_termination    = true
  data_disk_size_gb                = 30
  enable_ssh_key                   = true
  vm_size                          = "Standard_D2_v2"
  delete_data_disks_on_termination = true

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  enable_accelerated_networking = false
  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "linuxservers2" {
  count                            = 2
  source                           = "Azure/compute/azurerm"
  resource_group_name              = azurerm_resource_group.rg.name
  vm_hostname                      = "linuxvm-${count.index}"
  nb_public_ip                     = 0
  remote_port                      = "22"
  vm_os_publisher                  = "Canonical"
  vm_os_offer                      = "UbuntuServer"
  vm_os_sku                        = "18.04-LTS"
  vnet_subnet_id                   = azurerm_subnet.spoke2.id
  boot_diagnostics                 = false
  delete_os_disk_on_termination    = true
  data_disk_size_gb                = 30
  enable_ssh_key                   = true
  vm_size                          = "Standard_D2_v2"
  delete_data_disks_on_termination = true

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  enable_accelerated_networking = false
  depends_on = [
    azurerm_resource_group.rg
  ]
}