# cryptoprod

Installers for Cryptocurrencies daemon.

Each script set systemd service, compile from scratch and create an user for security.

## Ethereum Classic

Compatible with Ubuntu 16.04 LTS or newer.

### Usage with ETC

```shell
curl -fsSL -o ETC-installer.sh https://raw.githubusercontent.com/yograterol/cryptoprod/master/ETC-installer.sh && bash ETC-installer.sh
```

### Managing ETC daemon

```shell
sudo supervisorctl <start|restart|stop> ethereum-classic
```

Help the cause sending a donation in Ethereum Classic: `0x2140ee3413a79f814de83535aabd77785d903c79`
