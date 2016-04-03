#!/bin/bash

# Build your dockerized etcd cluster rapidly

SIZE=$1

if [[ $1 -lt 3 || $1 -gt 7 ]] ; then

	printf 'You must specify a cluster member count between 3 and 7\n\n'

	exit 0
fi

TOKEN=`curl -v --silent https://discovery.etcd.io/new?size=$SIZE 2>/dev/null |cut -f4 -d '/'`

docker run -d -e ETCD_TOKEN=$TOKEN  jsingerdumars/etcdeath
