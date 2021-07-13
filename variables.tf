variable "username" {
  description = "Username"
  type        = string
  default     = "mchaabane"
}

variable "password" {
  description = "Password"
  type        = string
  default     = "7ftKBCGK...."
}


variable "vshpere_server" {
  description = "Vshpere URI"
  type        = string
  default     = "192.168.1.2:443"
}
variable "allow_unverified_ssl" {
description = "allow unverified ssl"
type        = bool
default     = true
}
variable "datacenter_name" {
  description = "Name of datacenter"
  type        = string
  default     = "Datacenter"
}
variable "ressource_pool_ame" {
description = "Name of ressource pool"
type        = string
default     = "Resources"
}
variable "host_name" {
  description = "Host Name"
  type        = string
  default     = "srv-prod-3.lab.local"
}
variable "datastore_name" {
  description = "Datastore Name"
  type        = string
  default     = "HDD-DEV"
}

variable "datastore2_name" {
  description = "Datastore2 Name"
  type        = string
  default     = "install"
}

variable "vm_template_name" {
  description = "VM template name"
  type        = string
  default     = "ubunu18.04_server"
}
variable "network_label" {
  description = "Network label"
  type        = string
  default     = "dev"
}
variable "vm_name" {
  description = "Name of VM"
  type        = string
  default     = "vm-demo-terraformenx"
}
variable "folder_name" {
  description = "Name of folder"
  type        = string
  default     = "2 - Sandbox/Ansible-test"
}
variable "disk_label" {
  description = "Label of disk"
  type        = string
  default     = "disk0"
}
variable "memory_size" {
  description = "Memory size"
  type        = string
  default     = "4096"
}
variable "disk_size" {
  description = "disk size"
  type        = string
  default     = "20"
}
variable "cpu_number" {
  description = "Cpu number"
  type        = string
  default     = "2"
}
