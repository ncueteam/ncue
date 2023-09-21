from machine import Pin
from time import sleep
import dht
from umqttsimple import MQTTClient
import network

sensor = dht.DHT11(Pin(14))

sta_if = network.WLAN(network.STA_IF)
sta_if.active(True)
sta_if.connect('V2041', '123456789')

while not sta_if.isconnected():
    pass
print("connected")

client = MQTTClient(
    client_id="client",
    keepalive=5,
    server="test.mosquitto.org",
    ssl=False)

client.connect()

def get_msg(topic, msg):
    print(msg)

client.set_callback(get_msg)
client.subscribe("NCUEMQTT") #訂閱NCUE這個主題 

while True:
  try:
    client.check_msg()
    sensor.measure()
    temp = sensor.temperature()
    hum = sensor.humidity()
    temp_f = temp * (9/5) + 32.0
    string = str(hum) + " " + str(temp)
    print(string)
    
    client.publish("receive_topic", string) #向receive_topic這個主題送出訊號
    sleep(2)
    #print('Temperature: %3.1f C' %temp)
    #print('Temperature: %3.1f F' %temp_f)
    #print('Humidity: %3.1f %%' %hum)
  except OSError as e:
    print('Failed to read sensor.')
