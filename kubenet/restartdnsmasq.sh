#!/usr/bin/env bash
# Restarts dnsmasq while having a VM up
set -xe

brew services restart dnsmasq
if ! lsof -ni4TCP:53 | grep -q '192\.168\.1\.1'; then
  qemu-system-aarch64 \
      -nographic \
      -machine virt \
      -cpu cortex-a57 \
      -nic vmnet-shared,start-address=192.168.1.1,end-address=192.168.1.20,subnet-mask=255.255.255.0 \
      </dev/null >/dev/null 2>&1 &
  qemu_pid=$!
  sleep 1
  brew services restart dnsmasq
  until lsof -i4TCP:53 | grep -q vmhost; do sleep 1; done
  kill $qemu_pid
  wait $qemu_pid
fi