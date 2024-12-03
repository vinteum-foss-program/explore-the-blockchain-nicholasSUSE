#!/bin/bash

tx="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"
raw_tx=$(bitcoin-cli getrawtransaction $tx 1)
witness=$(echo "$raw_tx" | jq -r '.vin[0].txinwitness[]')

# Extract only the correct public key, ensuring the 21 prefix matches exactly and appears only once
public_key=$(echo "$witness" | grep -Eo '21(02|03)[0-9a-f]{64}' | head -n1 | cut -c3-)

echo $public_key
