// Azure - Ubuntu Packer Builder
packer {
  required_plugins {
    azure = {
      version = ">= 0.16.0"
      source  = "hashicorp/azurerm"
    }
  }
}

source "azure-arm" "ubuntu" {
  client_id = ""
  client_secret = ""
  subscription_id = ""
  tenant_id = ""
  resource_group_name = "packer-rg"
  virtual_machine_name = "packer-vm"
  os_type       = "Linux"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "20.04-LTS"
  image_version   = "latest"
  vm_size = "Standard_DS2_v2"
  managed_image_name = "pkr-myapp-v1.0.0-{{timestamp}}"
  managed_image_resource_group_name = "packer-rg"
}

build {
  sources = ["source.azure-arm.ubuntu"]

  provisioner "file" {
    source      = "myapp"
    destination = "/home/ubuntu/myapp"
  }

  provisioner "shell" {
    script = "./app.sh"
  }
}

