#!/usr/bin/with-contenv bash
# shellcheck shell=bash

if [ "${LOG_FILE}" = "true" ]; then
    DUCK_LOG="/config/duck.log"
    touch "${DUCK_LOG}"
    touch /config/logrotate.status
    /usr/sbin/logrotate -s /config/logrotate.status /app/logrotate.conf
else
    DUCK_LOG="/dev/null"
fi

if [ "${IPV6}" = "dual" ];
then
	{
	ipv4addr=$(curl -s -4 "https://ifconfig.io")
	ipv6addr=$(curl -s -6 "https://ifconfig.io")
	RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=${ipv4addr}&ipv6=${ipv6addr}")
	if [ "${RESPONSE}" = "OK" ]; then
		echo "Your IP ${ipv4addr} & ${ipv6addr} was updated at $(date)"
	else
		echo -e "Something went wrong, please check your settings $(date)\nThe response returned was:\n${RESPONSE}"
	fi
	} | tee -a "${DUCK_LOG}"
elif [ "${IPV6}" = "only" ];
then
	{
	ipv6addr=$(curl -s -6 "https://ifconfig.io")
	RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ipv6=${ipv6addr}")
	if [ "${RESPONSE}" = "OK" ]; then
		echo "Your IP ${ipv6addr} was updated at $(date)"
	else
		echo -e "Something went wrong, please check your settings $(date)\nThe response returned was:\n${RESPONSE}"
	fi
	} | tee -a "${DUCK_LOG}"
else
{
    RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=")
    if [ "${RESPONSE}" = "OK" ]; then
        echo "Your IP ${ipv4addr} was updated at $(date)"
    else
        echo -e "Something went wrong, please check your settings $(date)\nThe response returned was:\n${RESPONSE}"
    fi
} | tee -a "${DUCK_LOG}"
fi
