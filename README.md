# robustWIFI
Keep a headless Linux computer connected as your network environment changes

- [ ] TODO Enable disable apache2
- [ ] TODO Encrypted psk before storing
- [ ] TODO Add some data validation to SSID and PSK
- [ ] TODO Auto redirect 
- [ ] TODO Make it look nice
- [ ] TODO add script to cron time?
- [ ] TODO change wifi password
- [ ] Automated build
- [ ] TODO Python handle none type exception when no input is passed
- [ ] TODO find solution for safer file permissions where www-data writes the sid and psk


The idea is that if your device is unable to connect to wifi, it will broadcast it's own ssid, run a websever, allow you to add new wifi creds then be connected again. Never having to use a terminal or plug into router.

http://www.raspberryconnect.com/network/item/331-raspberry-pi-auto-wifi-hotspot-switch-no-internet-routing
