## ** VMware Host Terraform Deployment module**
### Euronext Usecase : 
VMware-1-ESXI-host-provisionning .

### Description:
This Terraform module deploys ESXi by booting a custom ISO image hosted on a HTTP server. 

The configuration of the ESXi Host (network, dns, ntp,...) and the ServerProfile name are provided as variables.

### Workflow Pre-requistes : 
- A Server Profile has been created and applied on a Synergy compute module.
- A tfvars file has been generated (one per ESXi deployment)

### Workflow Steps :
- Creation of a custom Kickstart file using the Terraform template based on the tfvars file
- Create of an ESXi custom ISO on the HTTP server
- Configure the Compute module to boot on the iLO Virtual Media thru HTTP.
- Power On the server

### Usage Example

```
$ cd src/vmware/host
$ terraform plan -var-file=example.tfvars
$ terraform apply -var-file=example.tfvars
```

### Variables

| Variable name        | Description | Type | Default Value |Example                             |
|----------------------|-------------|------|---------------|------------------------------------|
|`oneview_ip`|OneView IP Address|String||10.2.1.50|
|`oneview_username`|OneView Username|String|||
|`oneview_password`|OneView Password|String|||
|`oneview_apiversion`|OneView API Version|String||2600|
|`oneview_serverprofile_name`|OneView Server Profile Name of target installation|String||sp-esxi-deploy|
|`http_server`|HTTP Server URL|String||http://10.16.1.203/|
|`geniso_script`|Shell script to generate the ISO file|String|./scripts/geniso.sh||
|`geniso_geniso_output_dir`|Output directory for generated iso|String|/data/www/isos||
|`geniso_kickstart_dir`|Output directory for generated kickstart files|String|/data/esx_builds/kickstarts||
|`geniso_iso_filename`|Filename of the generated ISO file for the installation|String||esxi_example.iso|
|`geniso_esxi_baseimage_dir`|Directory holding ESXi baseimage files (extract of HPE Custom ESXi image)|String|/data/esx_builds/esxi70u2_euronext||
|`geniso_volumeid`|ISO VolumeID|String||ESXexample_ENX|
|`mount_virtualmedia`|Python script used to mount the VirtualMedia and reboot the server|String|./scripts/mount_virtual_media.py||
|`esxi_kickstart_template`|Terraform ESXi Kickstart template file|String|templates/ks_euronext_template.cfg.tpl||
|`esxi_kickstart_file`|Filename of the generated Kickstart|String|||./build/ks_esxbuild_example.cfg|
|`esxi_hostname`|ESXi Hostname|String|||
|`esxi_domainname`|ESXi Domain name|String|||
|`esxi_mgmtip`|ESXi IP Address|String|||
|`esxi_mgmtmask`|ESXi IP Mask|String|||
|`esxi_defaultgw`|ESXi IP Gateway|String|||
|`esxi_mgmtvlanid`|ESXi Portgroup VLAN ID|String|||
|`esxi_dnsservers`|DNS IP Address list|List(String)||["192.168.6.250", "192.168.6.251"]|
|`esxi_dnssearch`|DNS Search Domain list|List(String)||["domain.local"]|
|`esxi_ntpservers`|NTP server Address List|List(String)||["ntp1.domain.local", "ntp2.domain.local"]|
|`esxi_rootpasswd`|ROOT Encrypted password ($ character must be escaped with \\)|String|||
|`esxi_keyboard_layout`|Keyboard Layout|String|US Default||
|`esxi_target_adapter`|Name of the Adapter on which the installation will be performed|String||HPE Gen9 SmartArray: HPE Smart Array P240nr, HPE Gen10 SmartArray: HPE Smart Array E208i|
