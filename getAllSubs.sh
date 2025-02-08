#!/bin/bash

# Check if a domain is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <target.com>"
    exit 1
fi

domain="$1"

echo "[+] Running subfinder for $domain..."
subfinder -d "$domain" -all > subfinder.txt

echo "[+] Running assetfinder for $domain..."
assetfinder -subs-only "$domain" > assetfinder.txt

echo "[+] Fetching subdomains from crt.sh for $domain..."
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\\*\.//g' | sort -u > crtsh.txt

echo "[+] Merging and sorting results..."
cat *.txt | sort -u > all_subs.txt

echo "[+] Subdomain enumeration for $domain completed! Results saved in all_subs.txt"
