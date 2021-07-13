provider "vsphere" {
  user           = var.username
  password       = var.password
  vsphere_server = var.vshpere_server
  version = "1.15.0"
  # If you have a self-signed cert
  allow_unverified_ssl = var.allow_unverified_ssl
}
#### RETRIEVE DATA INFORMATION ON VCENTER ####
data "vsphere_datacenter" "dc" {
  name = var.datacenter_name
}
data "vsphere_resource_pool" "pool" {
  # If you haven't resource pool, put "Resources" after cluster name
  name          = var.ressource_pool_ame
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_host" "host" {
  name          = var.host_name
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Retrieve datastore information on vsphere
data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Retrieve datastore2 information on vsphere
data "vsphere_datastore" "datastore2" {
  name          = var.datastore2_name
  datacenter_id = data.vsphere_datacenter.dc.id
}


# Retrieve network information on vsphere
data "vsphere_network" "network" {
  name          = var.network_label
  datacenter_id = data.vsphere_datacenter.dc.id
}
# Retrieve template information on vsphere
data "vsphere_virtual_machine" "template" {
  name          = var.vm_template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

  

#### VM CREATION ####
# Set vm parameters
resource "vsphere_virtual_machine" "vm-demo-enx2" {
  name             = var.vm_name
  num_cpus         = var.cpu_number
  memory           = 4096
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  folder           = var.folder_name
  
  #set boot iso file
  cdrom {
    datastore_id = data.vsphere_datastore.datastore2.id
    path         = "WS2016/en_windows_server_2016_x64_dvd_9718492.iso"
  }

  # Set network parameters
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  # Use a predefined vmware template has main disk
  disk {
    label = var.disk_label
    size = var.disk_size
  }
/*
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "vm-one"
        domain    = "test.internal"
      }
      network_interface {
        ipv4_address    = "192.168.1.100"
        ipv4_netmask    = 24
        dns_server_list = ["8.8.8.8", "8.8.4.4"]
      }
      ipv4_gateway = "192.168.1.254"
    }
  }
*/


wait_for_guest_net_timeout = -1
wait_for_guest_ip_timeout  = -1

/*
  # Execute script on remote vm after this creation
  provisioner "remote-exec" {
    script = "scripts/example-script.sh"
    connection {
      type     = "ssh"
      user     = "root"
      password = "secret"
      host     = "192.168.1.254"
    }
  }
  */
}



