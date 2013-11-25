#!/bin/sh

# Assumes Tor is not already installed, will overwrite existing configuration.

FTEPROXY_VERSION=0.2.0
ARCH=`arch`
TMP_DIR=/tmp
CODENAME=`lsb_release -sc`

# download+install tor
sh -c "echo \"deb http://deb.torproject.org/torproject.org $CODENAME main\" >> /etc/apt/sources.list"
sh -c "echo \"deb http://deb.torproject.org/torproject.org experimental-$CODENAME main\" >> /etc/apt/sources.list"
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
apt-get update
apt-get -y install tor
apt-get -y install deb.torproject.org-keyring
curl https://raw.github.com/kpdyer/fteproxy/master/deployment/tor/torrc.server > /etc/tor/torrc

# download+install fte
cd $TMP_DIR
curl https://fteproxy.org/dist/fteproxy/linux/fteproxy-$FTEPROXY_VERSION-linux-$ARCH.tar.gz > fteproxy-$FTEPROXY_VERSION-linux-$ARCH.tar.gz
tar zxvf fteproxy-$FTEPROXY_VERSION-linux-$ARCH.tar.gz
mkdir -p /usr/local/fteproxy/bin
cp -rfv fteproxy-$FTEPROXY_VERSION-linux-$ARCH/* /usr/local/fteproxy/bin/

# restart tor to pickup fte changes
service tor restart