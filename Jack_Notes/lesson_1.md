# Lesson 01

## Running VMs with QEMU

My mac does not have apple silicon, updated command to remove HVF 
```bash
qemu-system-aarch64 \
    -machine virt 
```

Again, need to update this command to /usr/local/share/qemu for firmware files
```bash
qemu-system-aarch64 \
    -machine virt\
    -display default,show-cursor=on \
    -bios /usr/local/share/qemu/edk2-aarch64-code.fd
```

Final command after lots of pain around why the bios was not picked up
```bash
sudo qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a57 \
    -smp 2 \
    -m 1G \
    -bios /usr/local/share/qemu/edk2-aarch64-code.fd \
    -nic vmnet-shared \
    -hda ubuntu0.img
```

## cloud-init
- refresh iso:
  - mkisofs -output cidata.iso -volid cidata -joliet -rock cloud-init/{user-data,meta-data}
- user data / meta data used by cloud init

Adding new command `-drive file=cidata.iso,driver=raw,if=virtio`

```bash
sudo qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a57 \
    -smp 2 \
    -m 1G \
    -bios /usr/local/share/qemu/edk2-aarch64-code.fd \
    -nic vmnet-shared \
    -hda ubuntu0.img
    -drive file=cidata.iso,driver=raw,if=virtio
```

