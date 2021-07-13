#!/bin/bash

usage() {
cat << EOF
Usage:
  -d Directory for storing generated iso file
  -e Directory holding the base ESXi distribution files
  -k ESXi kickstart file
  -f Target ISO file
  -v ISO volumeid

Example:
./geniso.sh -d /data/www -e /data/esx_builds/esxi70u2_euronext -k /data/kickstarts/ks_esxbuild_example.cfg -f esxi_example.iso -v ESXi-Example
EOF
}

if [ $# -ne 10 ]
then
        usage
        exit 1
fi

while getopts d:e:k:f:v:h? opt
do
        case "${opt}" in
                d)    ISODIR=${OPTARG}
                      ;;
                e)    ESXIDIR=${OPTARG}
                      ;;
                k)    KS=${OPTARG}
                      ;;
                f)    ISO=${OPTARG}
                      ;;
                v)    VOLUMEID=${OPTARG}
                      ;;
        esac
done
cp ${KS} ${ESXIDIR}/KS_ENX.CFG
rm -f ${ISODIR}/${ISO}

KS="ks=cdrom:/KS_ENX.CFG"

if [[ ! $(grep ${KS} ${ESXIDIR}/boot.cfg) ]]
then
        sed -i "s|kernelopt.*|& $KS|g" ${ESXIDIR}/boot.cfg
fi


if [[ ! $(grep ${KS} ${ESXIDIR}/efi/boot/boot.cfg) ]]
then
        sed -i "s|kernelopt.*|& $KS|g" ${ESXIDIR}/efi/boot/boot.cfg
fi

cd ${ESXIDIR}
genisoimage -relaxed-filenames -V ${VOLUMEID} -A ESXIMAGE -sysid "" -o ${ISODIR}/${ISO} -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e efiboot.img -no-emul-boot ${ESXIDIR}
ls -l ${ISODIR}/${ISO}
isoinfo -d -i ${ISODIR}/${ISO}

sed -i "s|$KS||g" ${ESXIDIR}/boot.cfg
sed -i "s|$KS||g" ${ESXIDIR}/efi/boot/boot.cfg
