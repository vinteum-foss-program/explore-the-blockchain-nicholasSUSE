# How many new outputs were created by block 123,456?
# #!/bin/bash

block_hash=$(bitcoin-cli getblockhash 123456)
txids=$(bitcoin-cli getblock "$block_hash" true | jq -r '.tx[]')

total_outputs=0

for txid in $txids; do
  outputs=$(bitcoin-cli getrawtransaction "$txid" true | jq '.vout | length')
  total_outputs=$((total_outputs + outputs))
done

echo $total_outputs

