# /usr/bin/client-remove-notification.sh

#!/bin/sh

send_to_telegram() {
    logger -p local0.info -t dhcp-remove-notify "$1"
    token=$(uci get telegram-bot.mybot.token)
    chat_id=$(uci get telegram-bot.mybot.chat_id)
    if [[ -n "${token}" ]] && [[ -n "${chat_id}" ]]; then
        curl -skim 10 --data disable_notification="false" --data parse_mode="MarkdownV2" --data chat_id="$chat_id" --data-urlencode "text=$1" "https://api.telegram.org/bot${token}/sendMessage" > /dev/null
    else
        logger -p local0.info -t dhcp-remove-notify "Error: Your telegram chat_id or token is empty"
    fi
}

if [[ ! -f /tmp/wifi_clients.txt ]]; then
        cat /tmp/dhcp.leases | awk '{print $3,$4,$5}' > /tmp/wifi_clients.txt
fi
device_name=$(cat /tmp/sysinfo/model | sed 's/[^a-zA-Z0-9]//g')

while read -r line; do
    ip_address=$(echo "${line}" | awk '{print $1}')
    hostname=$(echo "${line}" | awk '{print $2}')
    mac_address=$(echo "${line}" | awk '{print $3}')

    ping -c 1 -w 11 "${ip_address}" > /dev/null 2>&1
    if [[ $? != 0 ]]; then # If client is DISCONNECTED from Wi-Fi
        sed -i "/${ip_address} ${hostname} ${mac_address}/d" /tmp/wifi_clients.txt
        local_msg="New device REMOVED from the network, sending it to telegram..."
        logger -p local0.info -t dhcp-remove-notify "$local_msg"
        send_to_telegram "\#$(echo "${hostname}" | sed 's/[^a-zA-Z0-9]//g') REMOVED from \#${device_name}:
\`\`\`
Time: $(date "+%A %d-%b-%Y %T")
Hostname: ${hostname}
IP Address: ${ip_address}
MAC Address: ${mac_address}
\`\`\`"
    fi
    sleep 1
done < /tmp/wifi_clients.txt

# THIS SCRIPT WAS WRITTEN BY https://www.facebook.com/galihpa/
# CHECK OUT THE GITHUB REPO AT: https://github.com/hillz2/OpenWrt_WiFi_Client_Notification
