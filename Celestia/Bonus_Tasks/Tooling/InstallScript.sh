#!/bin/bash
logo="
  ______   ______   ______   ______   ______  
 /_____/  /_____/  /_____/  /_____/  /_____/  
 
╔══╗╔╗──────╔╗─────────────╔╗
║╔╗║║║──────║║────────────╔╝╚╗
║╚╝╚╣║╔══╦══╣║╔╦══╦═╗╔══╦╗╠╗╔╝
║╔═╗║║║╔╗║╔═╣╚╝╣╔╗║╔╗╣╔╗║║║║║
║╚═╝║╚╣╚╝║╚═╣╔╗╣╚╝║║║║╔╗║╚╝║╚╗
╚═══╩═╩══╩══╩╝╚╩══╩╝╚╩╝╚╩══╩═╝
  ______   ______   ______   ______   ______ 
 /_____/  /_____/  /_____/  /_____/  /_____/  
"
echo -e "\033[0;32m $logo \033[0m"

echo -e "\033[0;32m Welcome to Celestia App, Consensus fullnode and Bridge node installation script \033[0m"
source $HOME/.bash_profile
# Install Environment & dependencies App
echo -e "\033[0;32m Do you want to install environment & install dependencies (y/n): \033[0m"
read install_environment

if [ "$install_environment" = "y" ]; then
    sudo apt update && sudo apt upgrade -y
    sudo apt install git -y
    sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
    echo -e "\033[0;32m Which go-version you want to install? (for example:1.20.3):  \033[0m"
    read goapp_version
    ver="$goapp_version" 
    cd $HOME 
    wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" --no-check-certificate 
    sudo rm -rf /usr/local/go 
    sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
    rm "go$ver.linux-amd64.tar.gz" 

    echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
    source $HOME/.bash_profile

else    
    echo -e "\033[0;32mSkipping environment installation...\033[0m"
fi

# Install Celestia App
echo -e "\033[0;32m Do you want to install Celestia App? (y/n): \033[0m"    
read install_celestia
         
if [ "$install_celestia" = "y" ]; then
    echo -e "\033[0;32mInstalling Celestia App...\033[0m"
    echo -e "\033[0;32mYou can check newest version here: https://github.com/celestiaorg/celestia-app/releases\033[0m"
    echo -e "\033[0;32m Which version you want to install? (for example:v0.12.2): \033[0m"   
    read app_version
    APP_VERSION=$app_version 
    cd $HOME 
    rm -rf celestia-app 
    git clone https://github.com/celestiaorg/celestia-app.git 
    cd celestia-app/ 
    git checkout tags/$APP_VERSION -b $APP_VERSION 
    make install 
                                                                                                            
else
    echo -e "\033[0;32mSkipping Celestia App installation...\033[0m"
fi

# Install Consensus full node
echo -e "\033[0;32mKeep in mind - you need to have installed Celestia App(Consensus full node) for running a consensus full node\033[0m"
echo -e "\033[0;32m Do you want to install Consensus full node on this machine? (y/n): \033[0m"   
read install_fullnode

if [ "$install_fullnode" = "y" ]; then
    #Setup the P2P Network
    echo -e "\033[0;32m Set your node-name : \033[0m"
    read node_name
    echo -e "\033[0;32m Choose a chain-id (atm blockspacerace-0 or mocha): \033[0m"
    read chain_id
    echo -e "\033[0;32m Do you want to configure pruning to lower disk space usage? For the blockspacerace you need to say n (y/n): \033[0m"
    read pruning
    
    cd $HOME
    rm -rf networks
    git clone https://github.com/celestiaorg/networks.git
    celestia-appd init $node_name --chain-id $chain_id
    cp $HOME/networks/blockspacerace/genesis.json $HOME/.celestia-app/config      
    if [ "$chain_id" = "blockspacerace-0" ]; then
        PERSISTENT_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/blockspacerace/peers.txt | tr '\n' ',')
        echo $PERSISTENT_PEERS
        sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PERSISTENT_PEERS\"/" $HOME/.celestia-app/config/config.toml                                                                    
    else
    PERSISTENT_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/peers.txt | tr -d '\n')
    echo $PERSISTENT_PEERS
    sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PERSISTENT_PEERS\"/" $HOME/.celestia-app/config/config.toml      
    fi                                                                                                 
    if [ "$pruning" = "y" ]; then                                                                                      
    PRUNING="custom"
    PRUNING_KEEP_RECENT="100"
    PRUNING_INTERVAL="10"

    sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.celestia-app/config/app.toml
    sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
    \"$PRUNING_KEEP_RECENT\"/" $HOME/.celestia-app/config/app.toml
    sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
    \"$PRUNING_INTERVAL\"/" $HOME/.celestia-app/config/app.toml
    else
    echo -e "\033[0;32mOk - we go on without pruning...\033[0m"
    fi
    
    echo -e "\033[0;32m Reset network: THIS WILL DELETE ALL DATA FOLDER! (y/n) \033[0m"
    read reset
    if [ "$reset" = "y" ]; then
    celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app
    else
    echo " "
    fi
    echo -e "\033[0;32mConensus full node installed.\033[0m"
fi

echo -e "\033[0;32mThis option will install celestia-node binary, which is (for blockspacerace) necessary to run the bridge node\033[0m"
echo -e "\033[0;32m Do you want to install Celestia bridge node? (y/n): \033[0m"
read install_bridgenode

if [ "$install_bridgenode" = "y" ]; then
    echo -e "\033[0;32m What RPC should be used? Write ip/domain inside or localhost if you installed Consensus full node on this machine : \033[0m"
    read ip_address
    echo -e "\033[0;32m Which version should be installed? Check here: https://github.com/celestiaorg/celestia-node/releases/ (for example: v0.9.1): \033[0m"
    read version_node
    cd $HOME 
    rm -rf celestia-node 
    git clone https://github.com/celestiaorg/celestia-node.git 
    cd celestia-node/ 
    git checkout tags/$version_node
    make build 
    make install 
    sudo mv build/celestia /usr/local/bin
    make cel-key 
    sudo cp cel-key /usr/local/bin
    fi
    echo -e "\033[0;32m Do you want create keys? (y/n): \033[0m"
    read create_key
    if [ "$create_key" = "y" ]; then
    cel-key add bridge-wallet --node.type bridge --p2p.network blockspacerace
    echo -e "\033[0;32m Safe your passphrase. Press Enter to continue \033[0m"
    read
fi
    if [ "$install_bridgenode" = "y" ]; then
    if [ "$chain_id" = "blockspacerace-0" ]; then
        celestia bridge init --core.ip $ip_address --p2p.network blockspacerace
    fi
    if [ "$chain_id" = "mocha" ]; then
        celestia bridge init --core.ip $ip_address
    fi
echo -e "\033[0;32mcelestia-node binary installed and initilized.\033[0m"
    fi

echo -e "\033[0;32m Do you want setting up SystemD processes for running node as a background process?(y/n) \033[0m"
read sysprocess
if [ "$sysprocess" = "y" ]; then
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-appd.service
[Unit]
Description=celestia-appd Cosmos daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which celestia-appd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable celestia-appd


sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-bridge.service
[Unit]
Description=celestia-bridge Cosmos daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which celestia) bridge start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable celestia-bridge


else
echo -e "\033[0;32mgo on without background process...\033[0m"
fi


echo -e "\033[0;32mInstallation completed\033[0m"
echo " "
echo -e "\033[0;32mYou can start your consensus full node with: celestia-appd start\033[0m"
echo " "
echo -e "\033[0;32mWhen it is synced you can start your blockspacerace bridge node with:\033[0m"
echo -e "\033[0;32mcelestia bridge start --core.ip <ip-address> --p2p.network blockspacerace\033[0m"
echo " "
echo -e "\033[0;32mWhen you are on the Mocha you can start your bridge node with:\033[0m"
echo -e "\033[0;32mcelestia bridge start --core.ip <ip-address>\033[0m"
echo -e "\033[0;32mIf you installed your consensus full node on the same server the core.ip is localhost\033[0m"
echo " "
echo -e "\033[0;32mChecking node status: curl <IP>:26657/status\033[0m"
echo " "
echo -e "\033[0;32mChecking bridge: journalctl -u celestia-bridge.service -f\033[0m"
