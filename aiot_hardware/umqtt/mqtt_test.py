import uasyncio
import connection
connection.bootLink()

def sub_cb(topic,msg):
        print(str(topic,"UTF-8")+","+str(msg,"UTF-8"))

def main():
    print("start!")
    from umqtt.simple import MQTTClient
    mqClient0 = MQTTClient('esp32_0419', 'test.mosquitto.org')
    mqClient0.connect()
    mqClient0.set_callback(sub_cb)
    mqClient0.subscribe(b"AIOT_113/AppSend")
    
    while True:
        mqClient0.publish(b'AIOT_113/Esp32Send', b'test message from Ayun')
        mqClient0.check_msg()
    mqClient0.disconnect()

main()
