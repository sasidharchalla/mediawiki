resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "vmNicConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

data "template_file" "jumpbox_bootstrap_script" {
  template = file("${path.module}/scripts/jumpbox_bootstrap_script.sh.tpl")
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group
  location              = var.location
  computer_name         = "jumpboxvm"
  size                  = "Standard_B2s"
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  admin_username        = "adminuser"

  os_disk {
    name                 = "jumpboxOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.keypair.public_key_openssh
  }

  custom_data = base64encode(data.template_file.jumpbox_bootstrap_script.rendered)

}

resource "azurerm_private_dns_zone_virtual_network_link" "hublink" {
  name                  = "hubnetdnsconfig"
  resource_group_name   = var.dns_zone_resource_group
  private_dns_zone_name = var.dns_zone_name
  virtual_network_id    = var.vnet_id

}