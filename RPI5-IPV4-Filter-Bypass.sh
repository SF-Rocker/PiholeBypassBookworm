#!/bin/bash

# Define your connection name and Pi-hole IP
CONNECTION_NAME="$CONNECTION_NAME" # Tethered Connection Name here
PIHOLE_IP="$PIHOLE_IP" # Put Pihole Address Here

echo "🔧 Binding $CONNECTION_NAME to Pi-hole at $PIHOLE_IP..."

# Step 1: Set Pi-hole as DNS and ignore auto-DNS
sudo nmcli connection modify "$CONNECTION_NAME" ipv4.dns "$PIHOLE_IP" # <
sudo nmcli connection modify "$CONNECTION_NAME" ipv4.ignore-auto-dns yes
sudo nmcli connection up "$CONNECTION_NAME"

# Step 2: Remove immutable flag from resolv.conf if present
sudo chattr -i /etc/resolv.conf 2>/dev/null

# Step 3: Override resolv.conf with Pi-hole DNS
sudo rm -f /etc/resolv.conf
echo "nameserver $PIHOLE_IP" | sudo tee /etc/resolv.conf

# Step 4: Lock resolv.conf to prevent future overwrites
sudo chattr +i /etc/resolv.conf

echo "✅ DNS binding complete. Pi-hole is now your vessel’s resolver."
