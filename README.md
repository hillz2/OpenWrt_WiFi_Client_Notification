# OpenWrt_WiFi_Client_Notification
Send a telegram notification every time a wifi client is connected / disconnected from your OpenWrt router.

## Tutorial:
1. Create a telegram bot at https://t.me/BotFather Copy your `BOT_TOKEN`
2. Start your bot by sending it any message.
3. On your browser, go to: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getupdates` you'll see something like this:
   ```
   {"ok":true,"result":[{"update_id":897000000,"message":{"message_id":2,"from":{"id":6341811111,"is_bot":false,"first_name":"500000","language_code":"en"},"chat":{"id":6341811111,"first_name":"500000","type":"private"},"date":1707224377,"text":"Test"}},{"update_id":897000000,
   ```
4. `6341811111` is your `CHAT_ID`. Copy that as well.
5. SSH to your OpenWrt router and do:
   ```
   touch /etc/config/telegram-bot
   uci set telegram-bot.mybot=wifibot
   uci set telegram-bot.mybot.token='YOUR_BOT_TOKEN'
   uci set telegram-bot.mybot.chat_id='YOUR_CHAT_ID'
   uci commit
   ```
6. Edit `/etc/dnsmasq.conf` and comment out the following line `log-facility=` so your `/etc/dnsmasq.conf` should look like this:
   ```
   #log-facility=
   ```
   Then restart the service: `/etc/init.d/dnsmasq restart`
7. Copy the script `98-client-join-notification` to your OpenWrt folder at `/etc/hotplug.d/dhcp/`
8. Copy the script `client-remove-notification.sh` to your OpenWrt folder at `/usr/bin/`
9. Make both scripts executable:
   ```
   chmod +x /etc/hotplug.d/dhcp/98-client-join-notification /usr/bin/client-remove-notification.sh
   ```
10. Edit your OpenWrt crontab with the command `crontab -e` like this:
    ```
    * * * * * /usr/bin/client-remove-notification.sh
    ```
11. Restart your crontab:
    ```
    /etc/init.d/cron restart
    ```
12. DONE. Try turning your wifi off / on, you should see a notification on your telegram account.

## Some Bugs:
1. When you reboot your router, you'll get a bunch of `New device JOINED your network` messages on telegram
2. When a device is removed from your network, it takes 1 minute to be notified on telegram

## Screenshots:
![Screenshot_2024-02-09-09-45-25-260_org telegram messenger-edit](https://github.com/hillz2/OpenWrt_WiFi_Client_Notification/assets/25127225/ef97d69e-fe20-446c-b724-67b4d6b55cfa)
![Screenshot_2024-02-09-09-49-06-305_org telegram messenger](https://github.com/hillz2/OpenWrt_WiFi_Client_Notification/assets/25127225/6545110f-c0ff-4cb8-8668-756fd451649d)

