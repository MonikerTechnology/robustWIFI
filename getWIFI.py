 #!/usr/bin/python3

# Import modules for CGI handling 
import cgi, cgitb 
import sys

# Create instance of FieldStorage 
form = cgi.FieldStorage() 
	
# Get data from fields
SSID = form.getvalue('SSID')
PSK  = form.getvalue('PSK')
	
update = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev"
update += "\nupdate_config=1"
update += "\ncountry=US"
update += "\n\nnetwork={"
update = update + '\n\tssid="' + SSID + '"'
update = update + '\n\tpsk="' + PSK + '"'
update +="\n}\n"
	
	
f = open("/wifi/wifi.conf","w")
f.write(update)
f.close()
	
	
print("Content-type:text/html\r\n\r\n")
print("<html>")
print("<head>")
print("<title>SSID and Password updated</title>")
print("</head>")
print("<body>")
print(update)
print("")
print("Restart device to finalize new settings")
print("</body>")
print("</html>")
