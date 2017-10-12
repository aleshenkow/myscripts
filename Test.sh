#!/usr/bin/env bash
echo "Enter port"
read port

if [ $port != 443 ] ; then
echo "$port is not secured"
elif [ $port = 443 ] ; then
    echo "port is secured"
fi

