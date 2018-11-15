#!/usr/bin/env bash

CITY="brussels"

function notify_admin() {
secret_key="3H5MYW9_mDaB7Cw83TG8V"
value1=$1
value2=$2
value3=$3
json="{\"value1\":\"${value1}\",\"value2\":\"${value2}\",\"value3\":\"${value3}\"}"
curl -X POST -H "Content-Type: application/json" -d "${json}" https://maker.ifttt.com/trigger/host-down/with/key/${secret_key}
}

function get_int_eth(){
	ethname=`ls /sys/class/net | grep eth* | head -1`
	echo $ethname
}

FILENAME="hosts"
INTERFACE=`get_int_eth`

while IFS='' read -r LINE || [[ -n "$HOSTIP" ]]; do

	IP="$(cut -d' ' -f1 <<<"$LINE")"
	HOSTNAME="$(cut -d' ' -f2 <<<"$LINE")"

    ping -c 2 -I $INTERFACE $IP >> /dev/null 2>&1
	if [ $? ==  0 ]
	then
		echo "host $IP : ok"
	else
		echo "host $HOSTNAME : down"
		notify_admin $HOSTNAME $IP $CITY
	fi
done < "$FILENAME"



