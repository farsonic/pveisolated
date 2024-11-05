#!/bin/bash

# Define the network interfaces directory
net_dir="/sys/devices/virtual/net"

# Initialize the table header
printf "%-15s %-10s %-5s %-10s\n" "Interface" "Isolated" "Type" "Local FW"

# Loop through each interface in the directory
for iface in $(ls $net_dir); do
    # Check if the interface is a tap or veth
    if [[ $iface == tap* || $iface == veth* $iface == vnet* ]]; then
        # Determine the type of interface
        if [[ $iface == tap* ]]; then
            type="PVE-KVM"
        if [[ $iface == tap* ]]; then
            type="KVM"
        elif [[ $iface == veth* ]]; then
            type="LXC"
        fi

        # Extract the unit number from the interface name
        unit_number=$(echo $iface | grep -o '[0-9]\+')

        # Check if there is a corresponding fwpr* interface
        if ls $net_dir/fwpr${unit_number}p* 1> /dev/null 2>&1; then
            local_fw="Yes"
        else
            local_fw="No"
        fi

        # Check if the isolated file exists
        if [ -f "$net_dir/$iface/brport/isolated" ]; then
            # Read the isolation status
            isolated=$(cat "$net_dir/$iface/brport/isolated")
            # Convert 0/1 to No/Yes
            if [ "$isolated" -eq 1 ]; then
                isolated="Yes"
            else
                isolated="No"
            fi
        else
            # Default to No if the file doesn't exist
            isolated="No"
        fi

        # Print the interface, its isolation status, type, and local FW status
        printf "%-15s %-10s %-5s %-10s\n" "$iface" "$isolated" "$type" "$local_fw"
    fi
done
