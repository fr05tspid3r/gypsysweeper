#!/bin/bash

if [ "$1" == '' ]; then
    echo 'You forgot to provide an IP address!'
    echo 'Syntax: ./ipsweep.sh 192.168.4'
else
    ip_address="$1"

    # Check if ips.txt file exists
    ips_file="ips.txt"
    if [ -f "$ips_file" ]; then
        echo "ips.txt file already exists."

        # Check if IP addresses are missing in the file
        missing_ips=""
        for ip in $(seq 1 254); do
            if ! grep -q "$ip_address.$ip" "$ips_file"; then
                missing_ips+=" $ip_address.$ip"
            fi
        done

        if [ -z "$missing_ips" ]; then
            echo "All IP addresses are already in the ips.txt file."
        else
            echo "Adding missing IP addresses to the ips.txt file."
            echo "$missing_ips" >> "$ips_file"
        fi
    else
        echo "Creating ips.txt file and adding IP addresses."
        for ip in $(seq 1 254); do
            echo "$ip_address.$ip" >> "$ips_file"
        done
    fi

    # Run Nmap on the collected IPs
    echo "Running Nmap on the collected IPs."
    for ip in $(cat "$ips_file"); do
        nmap "$ip"
    done
fi

