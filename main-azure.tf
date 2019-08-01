provider "azurerm" {}

resource "azurerm_resource_group" "rg" {
  name = "clelab"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "Labvnet"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["10.99.0.0/16"]
  location            = "${azurerm_resource_group.rg.location}"
}

resource "azurerm_availability_set" "avset" {
  name                         = "Webserveravset"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_route_table" "DMZ1RT" {
  name                = "DMZ1RT"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name           = "internal"
    address_prefix = "10.99.0.0/16"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem2"
    address_prefix = "10.2.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem5"
    address_prefix = "10.5.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  }

  resource "azurerm_route_table" "DMZ2RT" {
  name                = "DMZ2RT"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "DMZ3"
    address_prefix = "10.99.13.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "vnetlocal"
  }
  route {
    name           = "OnPrem"
    address_prefix = "10.2.0.0/16"
     next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem5"
    address_prefix = "10.5.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  }

  resource "azurerm_route_table" "DMZ3RT" {
  name                = "DMZ3RT"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
     next_hop_type  = "vnetlocal"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "DMZ3"
    address_prefix = "10.99.13.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem"
    address_prefix = "10.2.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  route {
    name           = "OnPrem5"
    address_prefix = "10.5.0.0/16"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.1.10"
  }
  }

  resource "azurerm_route_table" "GWRT" {
  name                = "GWRT"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name           = "DMZ1"
    address_prefix = "10.99.11.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }
  route {
    name           = "DMZ2"
    address_prefix = "10.99.12.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }
  route {
    name           = "DMZ3"
    address_prefix = "10.99.13.0/24"
    next_hop_type  = "VirtualAppliance"
	next_hop_in_ip_address = "10.99.0.10"
  }

  }

resource "azurerm_subnet" "External_subnet"  {
    name           = "External"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.0.0/24"
  }


  resource "azurerm_subnet" "Gateway_subnet"  {
      name           = "GatewaySubnet"
      resource_group_name  = "${azurerm_resource_group.rg.name}"
      virtual_network_name = "${azurerm_virtual_network.vnet.name}"
      address_prefix = "10.99.100.0/24"
    }

  resource "azurerm_subnet_route_table_association" "Gateway_Subnet_Assoc" {
    subnet_id      = "${azurerm_subnet.Gateway_subnet.id}"
    route_table_id = "${azurerm_route_table.GWRT.id}"
  }

resource "azurerm_subnet" "Internal_subnet"   {
    name           = "Internal"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.1.0/24"
  }
resource "azurerm_subnet" "DMZ1_subnet"  {
    name           = "DMZ1"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.11.0/24"
  }

resource "azurerm_subnet_route_table_association" "DMZ1_Subnet_Assoc" {
    subnet_id      = "${azurerm_subnet.DMZ1_subnet.id}"
    route_table_id = "${azurerm_route_table.DMZ1RT.id}"
  }

resource "azurerm_subnet" "DMZ2_subnet"  {
    name           = "DMZ2"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.12.0/24"
  }

resource "azurerm_subnet_route_table_association" "DMZ2_Subnet_Assoc" {
    subnet_id      = "${azurerm_subnet.DMZ2_subnet.id}"
    route_table_id = "${azurerm_route_table.DMZ2RT.id}"
  }

resource "azurerm_subnet" "DMZ3_subnet" {
    name           = "DMZ3"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix = "10.99.13.0/24"
  }

resource "azurerm_subnet_route_table_association" "DMZ3_Subnet_Assoc" {
    subnet_id      = "${azurerm_subnet.DMZ3_subnet.id}"
    route_table_id = "${azurerm_route_table.DMZ3RT.id}"
  }

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.rg.name}"
    }

    byte_length = 8
}

resource "azurerm_network_security_group" "scalesetnsg" {
  name                = "PermissiveSecurityGroup"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Permissive"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.rg.name}"
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

}

# Create Public IP for Load Balancer
resource "azurerm_public_ip" "albvip1" {
  name                         = "albvip1"
  sku                          = "Standard"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  allocation_method            = "Static"
  #domain_name_label            = "${azurerm_resource_group.rg.name}"
}

# Create Azure External Load Balancer
resource "azurerm_lb" "externallb" {
  name                = "externallb"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "ExternallbPublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.albvip1.id}"
  }
}

# Create Public IP for JumpHost
resource "azurerm_public_ip" "jumphostvip" {
  name                         = "jumphostvip1"
  sku                          = "basic"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  allocation_method            = "Dynamic"
  #domain_name_label            = "${azurerm_resource_group.rg.name}"
}

# Create Azure Backend address pool
resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.externallb.id}"
  name                = "BackEndAddressPool"
}

# Create Azure Probe
resource "azurerm_lb_probe" "chkpprobe" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.externallb.id}"
  name                = "chkp-probe"
  port                = 8117
}

# Create Azure Load Balancer Rule
resource "azurerm_lb_rule" "externallbrule" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.externallb.id}"
  name                           = "xlbName"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8090
  frontend_ip_configuration_name = "ExternallbPublicIPAddress"
  probe_id = "${azurerm_lb_probe.chkpprobe.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.bpepool.id}"
}

# Create Azure Load Balancer Rule
resource "azurerm_lb_rule" "RDPexternallbrule" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.externallb.id}"
  name                           = "RDP"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 33890
  frontend_ip_configuration_name = "ExternallbPublicIPAddress"
  probe_id = "${azurerm_lb_probe.chkpprobe.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.bpepool.id}"
}

# Create Azure Internal Load Balancer
resource "azurerm_lb" "internallb" {
  name                = "internallb"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "InternalLBipconfig"
    subnet_id            = "${azurerm_subnet.Internal_subnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.99.1.10"
  }
}

# Create Azure Internal Load Balancer for WebServers
resource "azurerm_lb" "WebServerilb" {
  name                = "WebServerilb"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "WebServerLBipconfig"
    subnet_id            = "${azurerm_subnet.Internal_subnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.99.1.11"
  }
}

# Create Azure Backend address pool
resource "azurerm_lb_backend_address_pool" "bpepoolinternal" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.internallb.id}"
  name                = "BackEndAddressPoolinternal"
}

# Create Azure Backend address pool for WebServers
resource "azurerm_lb_backend_address_pool" "bpepoolwebserver" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.WebServerilb.id}"
  name                = "BackEndAddressPoolWebservers"
}

# Create Azure Probe for WebServers
resource "azurerm_lb_probe" "WebServerprobei" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.WebServerilb.id}"
  name                = "http"
  port                = 80
  protocol            = "tcp"
}

# Create Azure Probe
resource "azurerm_lb_probe" "chkpprobei" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.internallb.id}"
  name                = "chkp-probe-internal"
  port                = 8117
}

# Create Azure Load Balancer Rule
resource "azurerm_lb_rule" "internallbrule" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.internallb.id}"
  name                           = "ilbName"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "InternalLBipconfig"
  probe_id = "${azurerm_lb_probe.chkpprobei.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.bpepoolinternal.id}"
}

# Create Azure Load Balancer Rule for Webservers
resource "azurerm_lb_rule" "WebServerlbrule" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.WebServerilb.id}"
  name                           = "WebServerlbName"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "WebServerLBipconfig"
  probe_id = "${azurerm_lb_probe.WebServerprobei.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.bpepoolwebserver.id}"
}

resource "azurerm_virtual_machine_scale_set" "chkpscaleset" {
  name                = "chkpscaleset-1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_D2_v2_Promo"
    tier     = "Standard"
    capacity = 2
  }

  plan {
       name = "sg-byol"
       publisher = "checkpoint"
       product = "check-point-cg-r8020-blink"
       }

  storage_profile_image_reference {
    publisher = "checkpoint"
    offer     = "check-point-cg-r8020-blink"
    sku       = "sg-byol"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = "chkpgw"
    admin_username       = "chkpadmin"
    admin_password       = "Cpwins1!"
    custom_data =  "#!/bin/bash\nblink_config -s 'gateway_cluster_member=false&ftw_sic_key=vpn12345&upload_info=true&download_info=true'\nExtAddr=\"$(ip addr show dev eth0 | awk \"/inet/{print \\$2; exit}\" | cut -d / -f 1)\"\nIntAddr=\"$(ip addr show dev eth1 | awk \"/inet/{print \\$2; exit}\" | cut -d / -f 1)\"\ndynamic_objects -n LocalGatewayExternal -r \"$ExtAddr\" \"$ExtAddr\" -a\ndynamic_objects -n LocalGatewayInternal -r \"$IntAddr\" \"$IntAddr\" -a\nshutdown -r now\n"

  }

  os_profile_linux_config {
    disable_password_authentication = false
      }

  network_profile {
    name    = "eth0"
    primary = true
    ip_forwarding = true
    network_security_group_id = "${azurerm_network_security_group.scalesetnsg.id}"

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary = true
      subnet_id                              = "${azurerm_subnet.External_subnet.id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
      public_ip_address_configuration {
        name = "scalesetpublicconfig"
        idle_timeout = "30"
        domain_name_label = "${azurerm_resource_group.rg.name}"
      }
    }

  }
  network_profile {
    name    = "eth1"
    primary = false
    ip_forwarding = true
    network_security_group_id = "${azurerm_network_security_group.scalesetnsg.id}"

    ip_configuration {
      name                                   = "TestIPConfiguration1"
      primary = true
      subnet_id                              = "${azurerm_subnet.Internal_subnet.id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepoolinternal.id}"]

    }

  }
  tags {
          x-chkp-template = "gcpstandard"
          x-chkp-management = "r80dot10mgmt"
          x-chkp-ip-address = "public"
          x-chkp-topology = "eth0:external,eth1:internal"
          x-chkp-anti-spoofing =  "eth0:true,eth1:false"
      }
}

resource "azurerm_monitor_autoscale_setting" "scalesetrules" {
  name                = "chkpAutoscaleSetting"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  target_resource_id  = "${azurerm_virtual_machine_scale_set.chkpscaleset.id}"

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 3
    }

    rule {
      metric_trigger {
        metric_name         = "Percentage CPU"
        metric_resource_id  = "${azurerm_virtual_machine_scale_set.chkpscaleset.id}"
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation    = "Average"
        operator            = "GreaterThan"
        threshold           = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name         = "Percentage CPU"
        metric_resource_id  = "${azurerm_virtual_machine_scale_set.chkpscaleset.id}"
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation    = "Average"
        operator            = "LessThan"
        threshold           = 60
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  notification {
    #operation = "Scale"
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
      custom_emails                         = ["youremail@here.com"]
    }
  }
}

resource "azurerm_network_interface" "ubuntuDMZ1" {
    name                = "ubuntuDMZ1"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ1Configuration"
        subnet_id                     = "${azurerm_subnet.DMZ1_subnet.id}"
        private_ip_address_allocation = "Static"
        private_ip_address = "10.99.11.10"
    }
}

resource "azurerm_network_interface_backend_address_pool_association" "backendwebserver_assoc1" {
  network_interface_id    = "${azurerm_network_interface.ubuntuDMZ1.id}"
  ip_configuration_name   = "ubuntuDMZ1Configuration"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.bpepoolwebserver.id}"
}

resource "azurerm_network_interface" "ubuntuDMZ2" {
    name                = "ubuntuDMZ2"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntuDMZ2Configuration"
        subnet_id                     = "${azurerm_subnet.DMZ2_subnet.id}"
        private_ip_address_allocation = "Static"
        private_ip_address = "10.99.12.10"
    }
}

resource "azurerm_network_interface_backend_address_pool_association" "backendwebserver_assoc2" {
  network_interface_id    = "${azurerm_network_interface.ubuntuDMZ2.id}"
  ip_configuration_name   = "ubuntuDMZ2Configuration"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.bpepoolwebserver.id}"
}

resource "azurerm_network_interface" "win_server_nic" {
    name                = "win_server_nic"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "WinServerNicConfiguration"
        subnet_id                     = "${azurerm_subnet.DMZ1_subnet.id}"
        private_ip_address_allocation = "Static"
        private_ip_address = "10.99.11.4"
    }
}

resource "azurerm_network_interface" "UbuntuJumpHostNIC" {
    name                = "Ubuntu-JumpHost-NIC"
    location            = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    enable_ip_forwarding = "false"
    ip_configuration {
        name                          = "ubuntujumphostConfiguration"
        subnet_id                     = "${azurerm_subnet.External_subnet.id}"
        private_ip_address_allocation = "Static"
        private_ip_address = "10.99.0.50"
        public_ip_address_id = "${azurerm_public_ip.jumphostvip.id}"
    }
}

resource "azurerm_virtual_machine" "ubuntudmz1" {
    name                  = "ubuntudmz1"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.ubuntuDMZ1.id}"]
    vm_size               = "Standard_B1s"
    availability_set_id   = "${azurerm_availability_set.avset.id}"

    storage_os_disk {
        name              = "ubuntudmz1disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz1"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
        custom_data =  "#!/bin/bash\nuntil sudo apt-get update && sudo apt-get -y install apache2;do\nsleep 1\n done\n until curl --output /var/www/html/vsec.jpg --url https://www.checkpoint.com/wp-content/uploads/cloudguard-iaas-236x150.png ; do \n sleep1 \n done\nsudo echo $HOSTNAME > /var/www/html/index.html\nsudo echo \"<BR><BR>Hello World - Check Point CloudGuard IAAS Demo !<BR><BR>\" >> /var/www/html/index.html\n sudo echo \"<img src=\"/vsec.jpg\" height=\"25%\">\" >> /var/www/html/index.html"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}

resource "azurerm_virtual_machine" "ubuntudmz2" {
    name                  = "ubuntudmz2"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.ubuntuDMZ2.id}"]
    vm_size               = "Standard_B1s"
    availability_set_id   = "${azurerm_availability_set.avset.id}"

    storage_os_disk {
        name              = "ubuntudmz2disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz2"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"
 custom_data =  "#!/bin/bash\nuntil sudo apt-get update && sudo apt-get -y install apache2;do\nsleep 1\n done\n until curl --output /var/www/html/vsec.jpg --url https://www.checkpoint.com/wp-content/uploads/cloudguard-iaas-236x150.png ; do \n sleep1 \n done\nsudo echo $HOSTNAME > /var/www/html/index.html\nsudo echo \"<BR><BR>Hello World - Check Point CloudGuard IAAS Demo !<BR><BR>\" >> /var/www/html/index.html\n sudo echo \"<img src=\"/vsec.jpg\" height=\"25%\">\" >> /var/www/html/index.html"


    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}

resource "azurerm_virtual_machine" "ubuntujumphost" {
    name                  = "ubuntujumphost"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.UbuntuJumpHostNIC.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "ubuntujumphostdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "dmz1"
        admin_username = "azureuser"
        admin_password = "Cpwins1!"

    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

}

resource "azurerm_virtual_machine" "win_server" {
  name                  = "winserver"
  location              = "eastus"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.win_server_nic.id}"]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "RS3-Pro"
    version   = "latest"
  }

  storage_os_disk {
    name              = "server-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name      = "winservertest"
    admin_username     = "azureuser"
    admin_password     = "Cpwins1!"

  }

  os_profile_windows_config {
  }

}
