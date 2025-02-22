#!/bin/bash

# Define your main network interface
INTERFACE="enp14s0"  # Change this to your primary interface name

# Capture the current network counters for download and upload
RX_PREV=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_PREV=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
sleep 1  # Wait one second to calculate the speed
RX_NEXT=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_NEXT=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

# Calculate download and upload speeds in KB/s
RX_RATE=$((($RX_NEXT - $RX_PREV) / 1024))
TX_RATE=$((($TX_NEXT - $TX_PREV) / 1024))

echo "D: ${RX_RATE}KB/s U: ${TX_RATE}KB/s"
