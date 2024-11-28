# Which tx in block 257,343 spends the coinbase output of block 256,128?


blockhash=$(bitcoin-cli getblockhash 257343)
block=$(bitcoin-cli getblock $blockhash)

tx_ids=$(echo $block | jq -r '.tx[]')


for txid in $tx_ids; do
  raw_tx=$(bitcoin-cli getrawtransaction $txid 1)
  raw_tx_vin_ids=$(echo $raw_tx | jq -r '.vin[].txid' | grep -v null)

  if [ -z "$raw_tx_vin_ids" ]; then
    continue
  fi

  for vin_txid in $raw_tx_vin_ids; do
    raw_tx_vin=$(bitcoin-cli getrawtransaction $vin_txid 1)
    in_blockhash=$(echo $raw_tx_vin | jq -r '.blockhash')

    if [ -z "$in_blockhash" ]; then
      continue
    fi

    in_blockheader=$(bitcoin-cli getblockheader "$in_blockhash")
    in_blockheight=$(echo $in_blockheader | jq -r '.height')
    if [ $in_blockheight -eq 256128 ]; then
      echo $txid
      exit 0
    fi
  done
done
