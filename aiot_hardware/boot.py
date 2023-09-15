# boot.py -- run on boot-up
import network
wlan = network.WLAN(network.STA_IF)
wlan.active(False)
wlan.active(True)
ssid = "Yunitrish"
password = "0937565253"
wlan.connect(ssid, password)
while not wlan.isconnected():
    pass
print("Connected to:", ssid)