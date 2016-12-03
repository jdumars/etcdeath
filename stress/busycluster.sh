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

# Busy cluster activity generator - you can run more than one at a time to really hit the cluster.

PAYLOAD_SIZE=32
PAYLOAD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $PAYLOAD_SIZE | head -n 1`

# Determine if md5 or md5sum

which md5sum
if [[ $? -eq 1 ]] ; then
	MD5=`which md5`
else
	MD5=`which md5sum`
fi

if [[ $UNATTENDED -eq 1 ]] ; then

        COUNT=1

        while [[ $COUNT -lt 999999999999 ]] ; do

                VAL=`echo $COUNT | $MD5 | cut -f1 -d ' ' `
		# Write key / val
                curl -L -X PUT http://$IP:2379/v2/keys/$VAL -d value=$PAYLOAD
		# Read key / val
		curl -L http://$IP:2379/v2/keys/$VAL
                COUNT=$[COUNT+1]
        done
        exit 0
fi

printf '\n'
printf 'Key count to write to etcd [ infinite ] : '
read -r COUNT

if [ -z $COUNT ] ; then
	
	COUNT=1

	while [ $COUNT -lt 999999999999 ] ; do

		VAL=`echo $COUNT | $MD5 | cut -f1 -d ' ' `
                # Write key / val
                curl -L -X PUT http://$IP:2379/v2/keys/$VAL -d value=$PAYLOAD
                # Read key / val
                curl -L http://$IP:2379/v2/keys/$VAL
                echo $COUNT
                COUNT=$[COUNT+1]

	done
	exit 0

else
	INC=1
	while [ $INC -le $COUNT ] ; do

                VAL=`echo $INC | $MD5 | cut -f1 -d ' ' `
                # Write key / val
                curl -L -X PUT http://$IP:2379/v2/keys/$VAL -d value=$PAYLOAD
                # Read key / val
                curl -L http://$IP:2379/v2/keys/$VAL
                echo $INC
                INC=$[INC+1]

  done
  exit 0

fi
	
