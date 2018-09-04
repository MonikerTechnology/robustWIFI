#!/bin/bash

sudo apt-get update

sudo apt-get install hostapd -y 
sudo apt-get install dnsmasq -y
sudo apt-get install apache2 -y

sudo systemctl disable hostapd
sudo systemctl disable dnsmasq


#########################################

# Configure hostapd
FILEPATH="/etc/hostapd/hostapd.conf"
echo "Configuring $FILEPATH"
echo "#2.4GHz setup wifi 80211 b,g,n
interface=wlan0
driver=nl80211
ssid=RPiHotspot
hw_mode=g
channel=8
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=1234567890
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP TKIP
rsn_pairwise=CCMP

#80211n - Change US to your WiFi country code
country_code=US
ieee80211n=1
ieee80211d=1" > $FILEPATH

#########################################

FILEPATH="/etc/default/hostapd"
echo "Configuring $FILEPATH"
echo DAEMON_CONF="/etc/hostapd/hostapd.conf" >> $FILEPATH

#########################################

FILEPATH="/etc/dnsmasq.conf"
echo "Configuring $FILEPATH"
echo '#AutoHotspot Config
#stop DNSmasq from using resolv.conf
no-resolv
#Interface to use
interface=wlan0
bind-interfaces
dhcp-range=10.0.0.50,10.0.0.150,12h' >> $FILEPATH

#########################################

# Back up network/interfaces
sudo cp /etc/network/interfaces /etc/network/interfaces-backup
FILEPATH="/etc/network/interfaces"
echo "Configuring $FILEPATH"
echo '# interfaces(5) file used by ifup(8) and ifdown(8) 
# Please note that this file is written to be used with dhcpcd 
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf' 
# Include files from /etc/network/interfaces.d: 
source-directory /etc/network/interfaces.d' > $FILEPATH

#########################################

# Configure dhcpcd
FILEPATH="/etc/dhcpcd.conf"
echo "Configuring $FILEPATH"
echo "nohook wpa_supplicant" > $FILEPATH

#########################################

# Configure autohotspot script
echo "Configuring autohotspot script"
sudo cp autohotspot.sh /usr/bin/
sudo chmod +x /usr/bin/autohotspot.sh
sed -i "3i$var" test

# Add a line to /usr/bin/autohotspot.sh to pull new wifi configs
sed -i '3imv /wifi/wifi.config /etc/wpa_supplicant/wpa_supplicant.conf 2> /dev/null && echo "New wifi settings!" || echo "no new wifi settings"' /usr/bin/autohotspot.sh
sed -i '3iecho "New wifi settings found, overwriting wpa_supplicant.conf"' /usr/bin/autohotspot.sh

#########################################

# Configure apache2
echo "Configuring apache2"
sudo a2enmod cgi
sudo cp index.html /var/www/html/
sudo cp getWIFI.py /usr/lib/cgi-bin/ 
chmod 755 /usr/lib/cgi-bin/getWIFI.py 

sudo mkdir /wifi
sudo chown www-data /wifi
sudo chmod 300 /wifi

sudo systemctl restart apache2

#########################################

# Configure service file
echo "Configuring autohotspot.service"
FILEPATH="/etc/systemd/system/autohotspot.service"
echo "Configuring $FILEPATH"
sudo cp autohotspot.service ${FILEPATH}
sudo systemctl enable autohotspot.service



