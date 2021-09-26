#!/bin/sh

# This script updates your IP address on DuckDNS
# Written-by: Erik Dahlinghaus
# License: GPLv2

# Configuration
# Domains are comma seperated
DOMAINS="simoon,simoongrocy,simoonphotos"
TOKEN= #token

echo "Checking IP..."

# Uses wtfismyip because they have nice plain text
NEWIP="`wget -q -O- http://wtfismyip.com/text`"
OLDIP="`cat ip`"

echo "Old: $OLDIP"
echo "New: $NEWIP"

if test $# != 0; then
  if test $1 = "force"; then
    echo "Forcing IP update"
    URL="https://www.duckdns.org/update?domains=$DOMAINS&token=$TOKEN&ip=$NEWIP"
    echo $URL
    curl -s -o duckdns.log $URL >> duckdns.log
    if test $? = 0; then
      echo $NEWIP > ip
      echo "IP updated"
      exit 0
    else
      echo "IP update FAILED. See duckdns.log"
      exit 1
    fi
  else
    echo "Invalid arguments -- ignoring"
  fi
fi

if test "$OLDIP" = "$NEWIP"; then
	echo "IP has not changed"
else
	echo "IP has changed"
	URL="https://www.duckdns.org/update?domains=$DOMAINS&token$TOKEN=&ip=$NEWIP"
	curl -s -o duckdns.log $URL >> duckdns.log
	if test $? = 0; then
	  echo "IP updated"
	  echo $NEWIP > ip
	  exit 0
	else
	  echo "IP update FAILED. See duckdns.log"
	  exit 1
	fi
fi
