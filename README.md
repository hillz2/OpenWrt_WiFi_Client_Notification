# OpenWrt_WiFi_Client_Notification
Send a telegram notification when a wifi client is connected / disconnected from your OpenWrt router, I've made the telegram notifications silent on purpose so that it won't be annoying when you get them a lot.

## Tutorial:
1. Create a telegram bot at https://t.me/BotFather Copy your `Bot Token`
2. Start your bot by sending it any message.
3. On your browser, go to: `https://api.telegram.org/bot<COPY_YOUR_BOT_TOKEN_HERE>/getupdates` you'll see something like this:
   ```
   {"ok":true,"result":[{"update_id":897000000,"message":{"message_id":2,"from":{"id":6341811111,"is_bot":false,"first_name":"500000","language_code":"en"},"chat":{"id":6341811111,"first_name":"500000","type":"private"},"date":1707224377,"text":"Test"}},{"update_id":897000000,
   ```
4. `6341811111` is your `chatID`. Copy that as well.
5. Open both scripts `98-client-join-notification` and `client-remove-notification.sh` and edit the variable `api_key` with your `Bot Token` and the variable `chatID` with your own `chatID` from step 4
6. Copy the script `98-client-join-notification` to your OpenWrt folder at `/etc/hotplug.d/dhcp/`
7. Copy the script `client-remove-notification.sh` to your OpenWrt folder at `/usr/bin/`
8. Make both scripts executable:
   ```
   chmod +x /etc/hotplug.d/dhcp/98-client-join-notification /usr/bin/client-remove-notification.sh
   ```
9. Edit your OpenWrt crontab with the command `crontab -e` like this:
    ```
    * * * * * /usr/bin/client-remove-notification.sh
    ```
10. Restart your crontab:
    ```
    /etc/init.d/cron restart
    ```
11. DONE. Try turning your wifi off / on, you should see a notification on your telegram account.

## Some Bugs:
1. When you reboot your router, you'll get a bunch of `New device JOINED your network` messages on telegram
2. When a device is removed from your network, it takes 1 minute to be notified on telegram

## Screenshot:
![2024-02-07-204829_1920x1080_scrot](https://github.com/hillz2/OpenWrt_WiFi_Client_Notification/assets/25127225/915d4f8b-de1b-4a75-abc4-7ef203dee1a5)
