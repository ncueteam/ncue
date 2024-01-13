import machine
import time
import ujson
class Comute():
    def __init__(self, mode="console",timer=machine.Timer(2),cir=None) -> None:
        import oled
        self.screen = oled.OLED(mode=mode)
        self.screen.display(["setting up","mqtt"])
        import file_system
        self.DB = file_system.FileSet('device_data.json')
        import ubinascii
        from umqtt.simple import MQTTClient
        self.port = MQTTClient(ubinascii.hexlify(machine.unique_id()), 'test.mosquitto.org', port=1883)
        self.port.connect()
        
        def sub_cb(topic,msg):
#             print(str(topic,"UTF-8")+","+str(msg,"UTF-8"))
            self.DB.handle_json(msg)
            if(self.DB.uuid==self.DB.read("uid")[1]):
                if self.DB.type=="ir_tx":
                    self.screen.display([self.DB.type,self.DB.protocol])
                    cir.sender.play([int(x) for x in self.DB.data[1:-1].split(',')])
                elif self.DB.type=="ir_rx":
                    self.screen.display([self.DB.type,self.DB.protocol,self.DB.data])
                    cir.receive()
                    print("ir_data")
        
        self.port.set_callback(sub_cb)
        self.port.subscribe(b"AIOT_113/AppSend")
        self.screen.display(["NCUE AIOT"])
        
        self.timer = timer
        self.last_ticks = 0

    def routine(self,dht):
        now = time.ticks_ms()
        if time.ticks_diff(now,self.last_ticks) > 120:
            self.last_ticks = now
            try:
                self.port.publish(b'AIOT_113/Esp32Send', ujson.dumps({"type":"dht11","uuid":self.DB.read("uid")[1],"humidity":dht.hum,"temperature":dht.temp}))
                self.port.check_msg()
            except Exception as e:
                return
        else:
            pass