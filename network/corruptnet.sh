#!/bin/bash

# You need to add a timeframe for automated runs so your CI engine can run tests against a jacked up system

RUNTIME=10

# cause network issues on your system

# Warning: this script will do very nasty things to your system and may result in you losing connectivity.  
# Super big warning to never run this script via cron, at, screen, tmux or nohup but you already know that.
# Random noise can be emulated with the corrupt option. This introduces a single bit error at a random offset in the packet.


if [[ $UNATTENDED -eq 1 ]] ; then

		# Use tc to jack up your nets - tweak these values to match your use case

		sudo sudo tc qdisc change dev eth0 root netem corrupt 15%
	
		# run time of script has to be limited before reset - tune this to match your CI engine

		sleep $RUNTIME	
                
               	# reset the system

		sudo tc qdisc del dev eth0 root netem
 
        exit 0
fi

printf '\n'
printf 'Packet loss likelihood percent [ 15 ] : '
read -r CORRUPTION

if [[ -z $CORRUPTION ]] ; then
        CORRUPTION=15
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

sudo sudo tc qdisc change dev eth0 root netem corrupt ${CORRUPTION}%

if [[ -z $PING ]] ; then

	ping -w $LENGTH 8.8.8.8

else

	sleep $LENGTH

fi

echo "Resetting network back to normal..."

sudo tc qdisc del dev eth0 root netem

echo "Done."

exit 0
