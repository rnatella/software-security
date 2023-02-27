#!/usr/bin/env bash

set -xe

VM_NAME="Ubuntu-SO"


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function wait_vm_shutdown {
    set +x
    while VBoxManage showvminfo $1 | grep -c "running (since"; do
    echo "Waiting for VM to shutdown..."
    sleep 1
    done
    sleep 2
    set -x
}

function wait_for_tcp_port {
    set +x
    while ! nc -z $1 $2; do
    echo "Waiting for TCP port $2 on $1 to be open..."
    sleep 1
    done
    sleep 2
    set -x
}


SSH_PORT=`vagrant port --guest 22 ${VM_TYPE}`
VB_UUID=`cat .vagrant/machines/default/virtualbox/id`


# To set "safe" ACPI shutdown by default for Virtualbox
VBoxManage setextradata ${VB_UUID} GUI/DefaultCloseAction Shutdown

# Cleanup
vagrant ssh -c 'bash /home/vagrant/ova-cleanup.sh'
sleep 5
VBoxManage controlvm ${VB_UUID} acpipowerbutton
wait_vm_shutdown ${VB_UUID}

# Remove vagrant shared folder
#VBoxManage sharedfolder remove ${VB_UUID} -name "vagrant"

# Remove *-configdrive.vmdk
VBoxManage storageattach ${VB_UUID} --storagectl "SCSI" --port 1 --medium none
UNUSED_VMDK_UUID=`VBoxManage list  hdds|perl -n -e '$uuid = $1 if(/^UUID:\s+(.+)$/); if(/^Location:\s+(.+)$/) { $location = $1; print "$location,$uuid\n" }' | grep ${VM_NAME} | grep "\-configdrive" | awk -F, '{print $2}'`
if [ "x${UNUSED_VMDK_UUID}" -ne "x" ]
then
    VBoxManage closemedium  disk ${UNUSED_VMDK_UUID} --delete
fi

rm -f ${VM_NAME}.ova
VBoxManage export ${VB_UUID} -o ${VM_NAME}.ova

