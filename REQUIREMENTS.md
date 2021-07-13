## ** Requirements **

### Euronext Usecase : 
VMware-1-ESXI-host-provisionning

#### Terraform automation server
- Terraform >= 0.15.1
- HTTP Server
- network connectivity to OneView and iLO Network

##### OS Requirements
- geniso package

##### Python3 modules
- hpeOneView >= 6.0, <= 6.1
- python-ilorest-library >= 3.2.1

#### Base ESXi image
- HPE ESXi 7.0.2 for Synergy : 
  VMware-ESXi-7.0.2-17867351-HPE-702.0.0.10.7.5.14-May2021-Synergy.iso
  https://my.vmware.com/en/web/vmware/downloads/details?downloadGroup=OEM-ESXI70U2-HPE&productId=974

#### ESXi encrypted password
To generate an encrypted password (SHA512)for the ESXi root username to set in your tfvars file :
```
$ mkpasswd --method=sha-512
```

### Installation of the requirements:

#### Python

```
$ apt install python3-pip
$ cd ./src/vmware/host/scripts
$ python3 -m pip install -r mount_requirements.txt
```

#### Base ESXi image

```
$ mount -o loop [path_to]/ VMware-ESXi-7.0.2-17867351-HPE-702.0.0.10.7.5.14-May2021-Synergy.iso [path_to_mountpoint]
$ cd [path_to_mountpoint]
$ mkdir 
```