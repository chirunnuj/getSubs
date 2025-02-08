#!/bin/bash

# Check if a domain is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <target.com> [subfinder|assetfinder|crtsh|all]"
    exit 1
fi

domain="$1"
method="$2"

if [ -z "$method" ]; then
    method="all"
fi

if [[ "$method" == "subfinder" || "$method" == "all" ]]; then
    echo "[+] Running subfinder for $domain..."
    subfinder -d "$domain" -all > subfinder.txt
fi

if [[ "$method" == "assetfinder" || "$method" == "all" ]]; then
    echo "[+] Running assetfinder for $domain..."
    assetfinder -subs-only "$domain" > assetfinder.txt
fi

if [[ "$method" == "crtsh" || "$method" == "all" ]]; then
    echo "[+] Fetching subdomains from crt.sh for $domain..."
    curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\\*\.//g' | sort -u > crtsh.txt
fi

if [[ "$method" == "all" ]]; then
    echo "[+] Merging and sorting results..."
    cat *.txt | sort -u > all_subs.txt
    echo "[+] Subdomain enumeration for $domain completed! Results saved in all_subs.txt"
else
    echo "[+] Enumeration for $method completed! Check the respective output file."
fi
