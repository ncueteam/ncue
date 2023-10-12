from machine import Pin
from ir_tx.nec import NEC
from time import sleep_ms
from umqtt.simple import MQTTClient
from umqtt.aiot import AIOT
import network

sta_if = network.WLAN(network.STA_IF)
sta_if.active(False)#<------------------------要記得!!!!!!!!!!!!!
sta_if.active(True)
sta_if.connect('V2041', '123456789')

while not sta_if.isconnected():
    pass
print("connected")

MAX_CYCLE = 100
client = MQTTClient(
            client_id="client",
            keepalive=MAX_CYCLE*2,
            server="test.mosquitto.org",
            ssl=False)

client.connect()

def get_msg(topic, msg):
    print(msg)

client.set_callback(get_msg)
client.subscribe("NCUEMQTT") #訂閱NCUE這個主題 

nec = NEC(Pin(32, Pin.OUT, value = 0))
sw = Pin(2, Pin.IN)

try:
    while True:
        #client.check_msg()  # 检查是否有新消息
        # 在此处执行其他任务或操作
#         if (client.check_msg()):
except KeyboardInterrupt:
    print("KeyboardInterrupt: Stopping program")
finally:
    client.disconnect()
    print("Disconnected from MQTT broker")

