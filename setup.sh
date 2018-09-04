#!bin/bash


sudo apt-get install hostapd -y 
sudo apt-get install dnsmasq -y

sudo systemctl disable hostapd
sudo systemctl disable dnsmasq


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


FILEPATH="/etc/default/hostapd"
echo "Configuring $FILEPATH"
echo "DAEMON_CONF="/etc/hostapd/hostapd.conf" >> $FILEPATH

FILEPATH="/etc/dnsmasq.conf"
echo "Configuring $FILEPATH"
echo "#AutoHotspot Config
#stop DNSmasq from using resolv.conf
no-resolv
#Interface to use
interface=wlan0
bind-interfaces
dhcp-range=10.0.0.50,10.0.0.150,12h" >> $FILEPATH


# Back up network/interfaces
sudo cp /etc/network/interfaces /etc/network/interfaces-backup
FILEPATH="/etc/network/interfaces"
echo "Configuring $FILEPATH"
echo "# interfaces(5) file used by ifup(8) and ifdown(8) 
# Please note that this file is written to be used with dhcpcd 
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf' 
# Include files from /etc/network/interfaces.d: 
source-directory /etc/network/interfaces.d" > $FILEPATH


FILEPATH="/etc/dhcpcd.conf"
echo "Configuring $FILEPATH"
echo "nohook wpa_supplicant" > $FILEPATH




