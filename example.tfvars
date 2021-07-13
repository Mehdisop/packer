// Default Variables
// http server
http_server="http://10.16.1.203/"
// OneView
oneview_ip="10.2.1.50"
oneview_username="Administrator"
oneview_password="password"
oneview_apiversion="2600"
oneview_serverprofile_name="sp-esxi-deploy"
mount_virtualmedia="./scripts/mount_virtual_media.py"
// Variables for the creation of the ISO and the Kickstart
geniso_script="./scripts/geniso.sh"
geniso_output_dir="/data/www/isos"
geniso_kickstart_dir="/data/www/kickstarts"
geniso_esxi_baseimage_dir="/data/esx_builds/esxi70u2_euronext"
geniso_iso_filename="esxi01.iso"
geniso_volumeid="ESXBuild4_ENX"

esxi_kickstart_template="templates/ks_euronext_template.cfg.tpl"
esxi_kickstart_file="ks_esxbuild_example.cfg"

// Variable for ESXi Configuration : network, ntp, dns,...
esxi_hostname="esxi03"
esxi_domainname="local"
esxi_mgmtip="10.16.1.110"
esxi_mgmtmask="255.255.255.0"
esxi_defaultgw="10.16.1.1"
esxi_mgmtvlanid=16
esxi_dnsservers=["10.16.1.1"]
esxi_dnssearch=["local"]
esxi_ntpservers=["10.16.1.1"]
esxi_rootpasswd="\\$1\\$hJ.2VcPn\\$lN5a0Q4DnwM7JO3mBMxDe1"
esxi_keyboard_layout="US Default"
esxi_target_adapter="HPE Smart Array P240nr"
