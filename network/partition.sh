#!/bin/bash

# You need to add a timeframe for automated runs so your CI engine can run tests against a jacked up system

RUNTIME=60

# cause network issues on your system

# Warning: this script will do very nasty things to your system and may result in you losing connectivity.  
# Super big warning to never run this script via cron, at, screen, tmux or nohup but you already know that.



if [[ $UNATTENDED -eq 1 ]] ; then

		# Use tc to jack up your nets - tweak these values to match your use case

		sudo tc qdisc add dev eth0 root netem delay 30000ms 20ms distribution normal
	
		# run time of script has to be limited before reset - tune this to match your CI engine

		sleep $RUNTIME	
                
               	# reset the system

		sudo tc qdisc del dev eth0 root netem
 
        exit 0
fi

printf '\n'
printf 'Partition length in milliseconds [ 30000 ] : '
read -r DELAY

if [[ -z $DELAY ]] ; then
	DELAY=30000
fi

SKEW=10
RANDOM=100

DUR=`expr $DELAY / 1000`

printf '\n'
printf 'Duration of partition in seconds [ '${DUR}' ] : '
read -r LENGTH

if [[ -z $LENGTH ]] ; then
        LENGTH=$DUR
fi

printf '\n'
printf 'Ping while you wait? [ y ] : '
read -r PING

printf '\n'
printf 'WARNING You are taking this system out for ' ${LENGTH} 'seconds. Are you sure?  [ n ] : '
read -r WARN

if [[ -z $WARN ]] ; then
        exit 0
fi


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
