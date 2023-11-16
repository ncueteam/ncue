import connection
connection.bootLink()

import file_system

DB = file_system.FileSet("device_data")

def sub_cb(topic,msg):
#         print(str(topic,"UTF-8")+","+str(msg,"UTF-8"))
        DB.handle_json(msg)
        print(DB.type)
        print(DB.clientID)
        print(DB.protocol)
        print(DB.data)
        
        

def link():
    print("link")

def main():
    print("start!")
    from umqtt.simple import MQTTClient
    import machine
    import ubinascii
    mqClient0 = MQTTClient(ubinascii.hexlify(machine.unique_id()), 'test.mosquitto.org')
    mqClient0.connect()
    mqClient0.set_callback(sub_cb)
    mqClient0.subscribe(b"AIOT_113/AppSend")
    
    while True:
        mqClient0.publish(b'AIOT_113/Esp32Send', b'test message from Ayun')
        mqClient0.check_msg()
    mqClient0.disconnect()

main()
