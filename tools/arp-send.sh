#!/bin/sh

_dev="$1"
_ipdst="$2"
_ipsrc="$3"
_macsrc="$4"
_macdst="$5"

# Alterar mac da interface
ip link set dev $_dev address $_macsrc 2>/dev/null
arpsend \
    -i $_dev \
    -E $_macsrc \
    -e $_macdst \
    -o 1 \
    -s $_ipsrc \
    -t $_ipdst \
    -c 1 \
    -p 1 \
    -w \
    -q
