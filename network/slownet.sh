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

# You need to add a timeframe for automated runs so your CI engine can run tests against a jacked up system

RUNTIME=10

# cause network issues on your system

# Warning: this script will do very nasty things to your system and may result in you losing connectivity.  
# Super big warning to never run this script via cron, at, screen, tmux or nohup but you already know that.



if [[ $UNATTENDED -eq 1 ]] ; then

		# Introduce random packet drops to PROB LOW - preference is to use tc instead

		# sudo iptables -A INPUT -m statistic --mode random --probability 0.1 -j DROP
		# sudo iptables -A OUTPUT -m statistic --mode random --probability 0.1 -j DROP 

		# Use tc to jack up your nets - tweak these values to match your use case

		sudo tc qdisc add dev eth0 root netem delay 50ms 20ms distribution normal
	
		# run time of script has to be limited before reset - tune this to match your CI engine

		sleep $RUNTIME	
                
               	# reset the system

		sudo tc qdisc del dev eth0 root netem
 
        exit 0
fi

printf '\n'
printf 'Delay in milliseconds [ 100 ] : '
read -r DELAY

if [[ -z $DELAY ]] ; then
	DELAY=100
fi

printf '\n'
printf 'plus or minus X milliseconds [ 10 ] : '
read -r SKEW

if [[ -z $SKEW ]] ; then
        SKEW=10
fi

printf '\n'
printf 'Incident likelihood percent [ 25 ] : '
read -r RANDOM

if [[ -z $RANDOM ]] ; then
        RANDOM=100
fi

printf '\n'
printf 'Duration of incident in seconds [ 20 ] : '
read -r LENGTH

if [[ -z $LENGTH ]] ; then
        LENGTH=20
fi

printf '\n'
printf 'Ping while you wait? [ y ] : '
read -r PING

# Execute the command

echo "Jacking up your network for $LENGTH seconds.  If you ctrl+c you need to manually reset your network!"
echo "$ sudo tc qdisc del dev eth0 root netem"

sudo tc qdisc add dev eth0 root netem delay ${DELAY}ms ${SKEW}ms ${RANDOM}%

if [[ -z $PING ]] ; then

	ping -w $LENGTH 8.8.8.8

else

	sleep $LENGTH

fi

echo "Resetting network back to normal..."

sudo tc qdisc del dev eth0 root netem

echo "Done."

exit 0
