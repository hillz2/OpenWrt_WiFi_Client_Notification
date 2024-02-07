# /usr/bin/client-remove-notification.sh

#!/bin/sh

send_to_telegram() {
    echo "$1"
    chatID="YOUR CHAT ID HERE"
    api_key="YOUR BOT TOKEN HERE"
    /usr/bin/curl -skim 15 --data disable_notification="true" --data parse_mode="MarkdownV2" --data chat_id="$chatID" --data-urlencode "text=$1" "https://api.telegram.org/bot${api_key}/sendMessage" > /dev/null
}

if [[ ! -f /tmp/wifi_clients.txt ]]; then
    cat /tmp/dhcp.leases | awk '{print $3,$4,$5}' > /tmp/wifi_clients.txt
else
    while read -r line; do
        ip_address=$(echo "${line}" | awk '{print $1}')
        hostname=$(echo "${line}" | awk '{print $2}')
        mac_address=$(echo "${line}" | awk '{print $3}')

        ping -c 3 -W 3 "${ip_address}" > /dev/null 2>&1
        if [[ $? != 0 ]]; then # If client is DISCONNECTED from Wi-Fi
            sed -i "/${ip_address} ${hostname} ${mac_address}/d" /tmp/wifi_clients.txt
            local_msg="New device REMOVED from the network, sending it to telegram..."
            logger -p local0.info -t dhcp-remove-notify "$local_msg"
            send_to_telegram "New device REMOVED from $(cat /tmp/sysinfo/model):
\`\`\`
Time: $(date "+%A %d-%b-%Y %T")
Hostname: ${hostname}
IP Address: ${ip_address}
MAC Address: ${mac_address}
\`\`\`"
        fi
        sleep 1
    done < /tmp/wifi_clients.txt
fi
# THIS SCRIPT WAS WRITTEN BY https://www.facebook.com/galihpa/
# CHECK OUT THE GITHUB REPO AT: https://github.com/hillz2/OpenWrt_WiFi_Client_Notification
