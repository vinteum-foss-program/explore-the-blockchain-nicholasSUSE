#!/bin/bash
# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`



rawtransaction=$(bitcoin-cli getrawtransaction 37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517)

decoded=$(bitcoin-cli decoderawtransaction $rawtransaction)

public_keys=($(echo "$decoded" | jq -r '.vin[].txinwitness[1]'))

# I HATE BASH!!!!
params="[\"${public_keys[0]}\", \"${public_keys[1]}\", \"${public_keys[2]}\", \"${public_keys[3]}\"]"


multisig=$(bitcoin-cli createmultisig 1 "$params")

address=$(echo "$multisig" | jq -r '.address')
echo $address