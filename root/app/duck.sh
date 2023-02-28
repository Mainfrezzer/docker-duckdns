#!/usr/bin/with-contenv bash

# shellcheck source=/dev/null
. /app/duck.conf
if [[ "${IPV6}" = "dual" ]];
then
	#!/bin/bash
	ipv4addr=$(curl -s -4 "https://ifconfig.io")
	ipv6addr=$(curl -s -6 "https://ifconfig.io")
	RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=${ipv4addr}&ipv6=${ipv6addr}")
	if [ "${RESPONSE}" = "OK" ]; then
		echo "Your IP was updated at $(date)"
	else
		echo -e "Something went wrong, please check your settings $(date)\nThe response returned was:\n${RESPONSE}"
	fi
elif [[ "${IPV6}" = "only" ]];
then
	ipv6addr=$(curl -s -6 "https://ifconfig.io")
	RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ipv6=${ipv6addr}")
	if [ "${RESPONSE}" = "OK" ]; then
		echo "Your IP was updated at $(date)"
	else
		echo -e "Something went wrong, please check your settings $(date)\nThe response returned was:\n${RESPONSE}"
	fi
else
	RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=")
	if [ "${RESPONSE}" = "OK" ]; then
		echo "Your IP was updated at $(date)"
	else
		echo -e "Something went wrong, please check your settings $(date)\nThe response returned was:\n${RESPONSE}"
	fi
fi
