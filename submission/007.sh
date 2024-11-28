#!/bin/bash
# Only one single output remains unspent from block 123,321. What address was it sent to?

blockhash=$(bitcoin-cli getblockhash 123321)
block=$(bitcoin-cli getblock $blockhash)
tx_ids=$(echo $block | jq -r '.tx[]')

for tx_id in $tx_ids; do
  raw_tx=$(bitcoin-cli getrawtransaction $tx_id 1)

  if [ -z "$raw_tx" ]; then
    continue
  fi

  vout=$(echo $raw_tx | jq -c '.vout')

  if [ -z "$vout" ] || [ "$vout" = "[]" ];then
    continue
  fi

  echo "$vout" | jq -c '.[]' | while read -r item; do
    n=$(echo "$item" | jq '.n')
    utxo=$(bitcoin-cli gettxout $tx_id $n true)
    if [ -z "$utxo" ]; then
        continue
    fi
    address=$(echo "$utxo" | jq -r '.scriptPubKey.address')
    echo $address
  done

done
