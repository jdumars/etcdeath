#!/bin/bash

# You need to add a timeframe for automated runs so your CI engine can run tests against a jacked up system

RUNTIME=10
CLIENT=2370
PEER=2380

# cause network issues on your system

# Warning: this script will do very nasty things to your system and may result in you losing connectivity.  
# Super big warning to never run this script via cron, at, screen, tmux or nohup but you already know that.
# This will block the ports you specify for the length you desire


if [[ $UNATTENDED -eq 1 ]] ; then

		sudo iptables -A INPUT -p tcp --destination-port $CLIENT -j DROP
		sudo iptables -A INPUT -p tcp --destination-port $PEER -j DROP

		# run time of script has to be limited before reset - tune this to match your CI engine

		sleep $RUNTIME	
                
               	# reset the system

		sudo iptables -A INPUT -p tcp --destination-port $CLIENT -j ACCEPT
		sudo iptables -A INPUT -p tcp --destination-port $PEER -j ACCEPT
		
 
        exit 0
fi

printf '\n'
printf 'Block [c]lient port, [p]eer port or [b]oth? [ b ] : '
read -r CPORT

if [[ -z $CPORT ]] ; then
        CPORT=b
fi

printf '\n'
printf 'Duration of incident in seconds [ 20 ] : '
read -r LENGTH

if [[ -z $LENGTH ]] ; then
        LENGTH=20
fi

# Execute the command

echo "Jacking up your firewall for $LENGTH seconds.  If you ctrl+c you need to manually reset your iptables rules!"
echo "$ sudo  iptables -A INPUT -p tcp --destination-port $CLIENT -j ACCEPT && sudo iptables -A INPUT -p tcp --destination-port $PEER -j ACCEPT"

if [[ $CPORT == "b" ]] ; then

	sudo iptables -A INPUT -p tcp --destination-port $CLIENT -j DROP
	sudo iptables -A INPUT -p tcp --destination-port $PEER -j DROP

elif [[ $CPORT == "c" ]] ; then

	sudo iptables -A INPUT -p tcp --destination-port $CLIENT -j DROP

elif [[ $CPORT == "p" ]] ; then

	sudo iptables -A INPUT -p tcp --destination-port $PEER -j DROP

fi

	sleep $LENGTH

fi

echo "Resetting firewall  back to normal..."

	sudo iptables -A INPUT -p tcp --destination-port $CLIENT -j ACCEPT
	sudo iptables -A INPUT -p tcp --destination-port $PEER -j ACCEPT

echo "Done."

exit 0
