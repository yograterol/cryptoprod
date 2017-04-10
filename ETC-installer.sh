#!/usr/bin/env bash
# MIT License
# Copyright (c) 2017 Yohan Graterol
# This installer was support only for Ubuntu (for now)

HOME_GETH=/home/geth
ETC_DIRECTORY=$HOME_GETH/go/src/github.com/ethereumproject
set -e

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

echo "Hello, "$USER".  This script will install Ethereum Classic node."
echo -n "Enter the amount (in Megabytes) of disk that you'll allocate for Ethereum Classic (ex. 512) [ENTER]: "
read CACHE_SIZE

if [[ -n ${CACHE_SIZE//[0-9]/} ]]; then
    echo "It can't Contains letters!"
    exit 1
fi

if [ $CACHE_SIZE -lt 512 ]; then
  echo "Ethereum Classic Devs recommend minimum 512, this script sets 512 to allocate in disk."
  CACHE_SIZE = 512
fi

echo "Cleaning before instalation..."
echo "Removing geth user"
userdel geth || true  2> /dev/null
rm -rf $HOME_GETH || true  2> /dev/null
rm -f /etc/systemd/system/ethereum-classic.service

cat <<EOT >> /etc/systemd/system/ethereum-classic.service
[Unit]
Description=Geth Service

[Service]
WorkingDirectory=/home/geth/
ExecStart=sudo su - geth -c "/usr/bin/geth --fast --cache=$CACHE_SIZE"
Restart=always
User=geth
Group=geth

[Install]
WantedBy=multi-user.target
EOT

useradd -m -U geth
add-apt-repository -y ppa:longsleep/golang-backports
apt-get update
apt-get upgrade -y
apt-get install -y git build-essential software-properties-common golang-go
runuser -l geth -c "mkdir -p $ETC_DIRECTORY && cd $ETC_DIRECTORY && git clone https://github.com/ethereumproject/go-ethereum.git"
runuser -l geth -c "cd $ETC_DIRECTORY/go-ethereum && go get -t -v ./... && go build ./cmd/geth && cp geth $HOME_GETH && cd $HOME_GETH && rm -rf go"
mv /home/geth/geth /usr/bin/

apt-get remove -y golang-go git

systemctl daemon-reload
systemctl enable ethereum-classic.service
systemctl start ethereum-classic.service
