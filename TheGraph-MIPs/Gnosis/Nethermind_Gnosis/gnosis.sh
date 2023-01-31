#!/bin/bash
sudo apt-get update && upgrade -y
sudo apt-get install libsnappy-dev libc6-dev libc6 unzip build-essential git -y
cd ~
curl -LO https://github.com/NethermindEth/nethermind/releases/download/1.16.1/nethermind-1.16.1-644fe89f-linux-x64.zip
unzip nethermind-1.16.1-644fe89f-linux-x64.zip -d nethermind
sudo cp -a nethermind /usr/local/bin/nethermind
sudo rm nethermind-1.16.1-644fe89f-linux-x64.zip
sudo rm -r nethermind
sudo useradd --no-create-home --shell /bin/false nethermind
sudo mkdir -p /var/lib/nethermind
sudo chown -R nethermind:nethermind /var/lib/nethermind
sudo chown -R nethermind:nethermind /usr/local/bin/nethermind
sudo mkdir -p /var/lib/jwtsecret/nethermind
openssl rand -hex 32 | sudo tee -a /var/lib/jwtsecret/jwt.hex > /dev/null



curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee -a /etc/apt/sources.list.d/yarn.list > /dev/null
sudo apt update -y && sudo apt install yarn -y
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

git clone https://github.com/chainsafe/lodestar.git
cd lodestar
git checkout v1.4.0
yarn install --ignore-optional
yarn run build
cd ~
sudo cp -a lodestar /usr/local/bin
sudo rm -r lodestar
sudo useradd --no-create-home --shell /bin/false lodestarbeacon
sudo mkdir -p /var/lib/lodestar/beacon
sudo chown -R lodestarbeacon:lodestarbeacon /var/lib/lodestar/beacon

echo "[Unit]
Description=Lodestar Consensus Beacon Client (Gnosis)
Wants=network-online.target
After=network-online.target
[Service]
User=lodestarbeacon
Group=lodestarbeacon
Type=simple
Restart=always
RestartSec=5
WorkingDirectory=/usr/local/bin/lodestar
ExecStart=/usr/local/bin/lodestar/lodestar beacon \
  --network gnosis \
  --dataDir /var/lib/lodestar/beacon \
  --execution.urls http://127.0.0.1:8551 \
  --checkpointSyncUrl https://checkpoint.gnosis.gateway.fm/ \
  --jwt-secret /var/lib/jwtsecret/jwt.hex
  --bootnodes enr:-KG4QKWOgedErRLsanl1AUjTFnHB-RO9OsyFP-vtSrX2VGxRBdvoJVrzBJwgGYLIBiDjqy0eYJ2r8ZosAjkWhQ02koUGhGV0aDKQgkvkMQIAAGT__________4JpZIJ2NIJpcISf39WdiXNlY3AyNTZrMaEDYAuZlJpKwWdGtbSrVgy6N5sdMjehVglGMGGkBCFg_VeDdGNwgiMog3VkcIIjKA \
  --bootnodes enr:-KG4QBart9YQV5Ju3EMxUUnJ0ntgYf7J6jDbEPySiR7R8gJ9DcTp22gArHqWSMQVyt0-TMnuZrZQCprcaka5J8B9JN8GhGV0aDKQgkvkMQIAAGT__________4JpZIJ2NIJpcISf39G5iXNlY3AyNTZrMaED13MHlUcbr4978YYNRurZtykey8gTY_O5pQ4a427ZICuDdGNwgiMog3VkcIIjKA \
  --bootnodes enr:-KG4QLk-EkZCAjhMaBSlB4r6Icrz137hIx6WXg5AKIXQl9vkPt876WxIhzu8dVPCLVfaPzjAsIjXeBUPy2E3VH4QEuEGhGV0aDKQgkvkMQIAAGT__________4JpZIJ2NIJpcISf39n5iXNlY3AyNTZrMaECtocMlfvwxqouGi13SSdG6Tkn3shkyBQt1BIpF0fhXc-DdGNwgiMog3VkcIIjKA \
  --bootnodes enr:-KG4QDXI2zubDpp7QowlafGwwTLu4w-gFztFYNnA6_I0vrpaS9bXQydY_Gh8Dc6c7cy9SHEi56HRfle9jkKIbSRQ2B8GhGV0aDKQgkvkMQIAAGT__________4JpZIJ2NIJpcISf39WiiXNlY3AyNTZrMaECZ2_0tLZ9kb0Wn-lVNcZEyhVG9dmXX_xzQXQq24sdbZiDdGNwgiMog3VkcIIjKA \
  --bootnodes enr:-LK4QPnudCfJYvcmV-LjJBU5jexY3QTdC1PepWK08OHb4w_BJ3OgFbh0Bc2nb1WRK6p2CBNOPAixpPrtAvmNQPgegDgBh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBW_bXgAQAAZP__________gmlkgnY0gmlwhJO2zMWJc2VjcDI1NmsxoQKk8-B9o94CY2UUK2bxPpl-T_yHmTtE7rAPaT26M4w09YN0Y3CCIyiDdWRwgiMo \
  --bootnodes enr:-LK4QArhQjC_S3CwptV7balWpNP5IVKweAqZzvq93vz_zN_ZSruOxBU5ECgqOBUFHO1nYUveOYVeiEKswg637rOURDABh2F0dG5ldHOIAAAAAAAAAACEZXRoMpBW_bXgAQAAZP__________gmlkgnY0gmlwhIm4t0GJc2VjcDI1NmsxoQIj9iJm4h7OAhhCoUcqfn41_fj9F7UfKnISj_-xqKH834N0Y3CCIyiDdWRwgiMo \
  --bootnodes enr:-Ly4QClooKhmB409-xLE52rTmC2h9kZBO_VFXR-kjqLDdduuZoxsjfwTxa1jscQMBpqmezG_JCwPpEzEYRM_1UCy-0gCh2F0dG5ldHOIAAAAAAAAAACEZXRoMpCCS-QxAgAAZP__________gmlkgnY0gmlwhKXoiruJc2VjcDI1NmsxoQLLYztVAaOL2dhsQf884Vth9ro6n9p2yj-osPfZ0L_NwYhzeW5jbmV0cwCDdGNwgiMog3VkcIIjKA 
[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/lodestarbeacon.service > /dev/null

echo "[Unit]
Description=Nethermind Execution Client (Gnosis)
After=network.target
Wants=network.target
[Service]
User=nethermind
Group=nethermind
Type=simple
Restart=always
RestartSec=5
WorkingDirectory=/var/lib/nethermind
Environment="DOTNET_BUNDLE_EXTRACT_BASE_DIR=/var/lib/nethermind"
ExecStart=/usr/local/bin/nethermind/Nethermind.Runner \
  --config /usr/local/bin/nethermind/configs/xdai_archive.cfg \
  --datadir /var/lib/nethermind \
  --JsonRpc.JwtSecretFile=/var/lib/jwtsecret/jwt.hex \
  --Metrics.Enabled true \
  --TraceStore.Enabled true \
  --TraceStore.BlocksToKeep 0 \
  --Metrics.ExposePort 6969 \
  --JsonRpc.Enabled true \
  --JsonRpc.Timeout 20000 \
  --JsonRpc.Host 127.0.0.1 \
  --JsonRpc.Port 9545 \
  --JsonRpc.EnabledModules Eth,Trace,TxPool,Web3,Personal,Proof,Net,Parity,Health,Rpc
[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/nethermind.service > /dev/null

sudo systemctl daemon-reload
sudo systemctl start nethermind
sudo systemctl enable nethermind
sudo systemctl enable lodestarbeacon
