# Lesson 2
## Configuring MAC address and setting up DHCP

Dynamic Host Configuration Protocol (DHCP) is a protocol for automatically assigning IP addresses and other configurations to devices when they connect to a network.


```bash
sudo qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a57 \
    -smp 2 \
    -m 2G \
    -bios /usr/local/share/qemu/edk2-aarch64-code.fd \
    -nic vmnet-shared \
    -hda gateway/disk.img \
    -drive file=gateway/cidata.iso,driver=raw,if=virtio
```

Adding fixed MAC address to each VM to map to a static IP via dnsmasq
```bash
sudo qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a57 \
    -smp 2 \
    -m 2G \
    -bios /usr/local/share/qemu/edk2-aarch64-code.fd \
    -nic vmnet-shared,...,mac=52:52:52:00:00:0$vmid
    -hda gateway/disk.img \
    -drive file=gateway/cidata.iso,driver=raw,if=virtio
```

updating dnsmasq config file
```bash
cat /usr/local/etc/dnsmasq.conf
```
dhcp-range=192.168.1.2,192.168.1.20,12h
dhcp-host=52:52:52:00:00:00,192.168.1.10
dhcp-host=52:52:52:00:00:01,192.168.1.11
dhcp-host=52:52:52:00:00:02,192.168.1.12
dhcp-host=52:52:52:00:00:03,192.168.1.13
dhcp-host=52:52:52:00:00:04,192.168.1.14
dhcp-host=52:52:52:00:00:05,192.168.1.15
dhcp-host=52:52:52:00:00:06,192.168.1.16
dhcp-authoritative

updating /etc/hosts - VMs know their hostnames via meta-data. Now we need to make sure that the host machine and VMs can refer to each other using these hostnames. In other words, we need to configure a DNS server.

```bash
sudo nano /private/etc/hosts
```
192.168.1.1   vmhost
192.168.1.10  gateway
192.168.1.11  control0
192.168.1.12  control1
192.168.1.13  control2
192.168.1.14  worker0
192.168.1.15  worker1
192.168.1.16  worker2
192.168.1.21  kubernetes

restarting to pick up changes
```bash
restartdnsmasq.sh
```

Run ip addr on the VM to see if it got the right IP:
Run ip route to see if the VM got the right default gateway:
Validate the DNS configuration with resolvectl status:
 test DNS resolution with resolvectl query (or other like nslookup, dig, etc.)

