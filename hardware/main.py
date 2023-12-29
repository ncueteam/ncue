import connection
import time
class core():
    def __init__(self,screenOn=False):
        self.net = connection.Network(screenMode="oled")
        self.status = "wifi_not_connected"
        self.ir_data = -1
        self.ir_addr = -1
        self.ble_try = 0
        import file_system
        self.DB = file_system.FileSet('device_data.json')
        import oled
        if screenOn:
            self.screen = oled.OLED(mode="oled")
        else:
            self.screen = oled.OLED(mode="console")
        
    def setUp(self):
        self.status = "wifi_connecting"
        self.net.setUp()
        self.screen.display(["setting up..."])
        time.sleep(2)
        self.screen.display(["trying to","connect wifi ..."])
        import dht11
        self.dht = dht11.Sensor(mode="oled")
    
    def connecting(self):
        if self.net.isConnected():
            self.status = "wifi_connected"
        else:
            self.status = "ble_mode"
    
    def ble_setup(self):
        if self.ble_try==0:
            self.screen.display(["BLE","Connect","Mode"])
            import ble
            self.bt = ble.BLE(mode="oled")
            self.bt.wifi_added = False
            self.bt.bt_linked = False
            time.sleep(2)
            self.screen.display(["BLE name",self.bt.name])
            time.sleep(2)
        if self.ble_try<=10:
            if (self.bt.wifi_added):
                self.screen.display(["wifi added!"])
                self.ble_try = 0;
                self.status = "wifi_not_connected"
                self.ble = ""
                time.sleep(2)
            elif (self.bt.bt_linked):
                self.screen.display(["bt linked!"])
                time.sleep(2)
            else:                
                self.ble_try+=1
                self.screen.display([self.bt.name,str(self.ble_try)+" / 10"])
                time.sleep(2)
        else:
            self.ble_try = 0;
            self.ble = ""
            self.status = "wifi_not_connected"
    
    def wifi_connected(self):
        import ir_system
        self.cir = ir_system.IR(mode="oled")
        import machine
        import file_system
#         from ir_system.ir_tx import Player
        self.RDB = file_system.FileSet('remote_data.json')
#         self.ir = Player(machine.Pin(32, machine.Pin.OUT, value = 0))
#         from ir_system.ir_rx.nec import NEC_16
#         def ir_callback(data, addr, ctrl):
#             if data >= 0:
#                 self.ir_data = data
#                 self.ir_addr = addr
#                 print('Data {:02x} Addr {:04x}'.format(data, addr))
#         self.ir_rx = NEC_16(machine.Pin(23, machine.Pin.IN), ir_callback)
        
        from umqtt.simple import MQTTClient
        import ubinascii
        self.mqttc = MQTTClient(ubinascii.hexlify(machine.unique_id()), 'test.mosquitto.org')
        self.mqttc.connect()
        def sub_cb(topic,msg):
#             print(str(topic,"UTF-8")+","+str(msg,"UTF-8"))
            self.DB.handle_json(msg)
            if(self.DB.uuid==self.DB.read("uid")[1]):
                if self.DB.type=="ir_tx":
                    self.screen.display([self.DB.type,self.DB.protocol,self.DB.data])
                    time.sleep(3)
                    self.cir.receive()
#                     if self.DB.protocol=="NEC8":
#                         self.ir_tx.transmit(0x0000, int(self.DB.data))
#                     elif self.DB.protocol=="NEC16":
#                         self.ir_tx.transmit(0x0000, int(self.DB.data))
                elif self.DB.type=="ir_rx":
                    self.screen.display([self.DB.type,self.DB.protocol,self.DB.data])
                    time.sleep(3)
                    self.cir.receive()
                    print("ir_data")
                elif(self.DB.type=="register_device"):
                    if self.DB.type_data=="switch":
                        self.DB.create(self.DB.uuid,self.DB.type_data)
                    elif self.DB.type_data=="slide_device":
                        self.DB.create(self.DB.uuid,self.DB.type_data)
                    elif self.DB.type_data=="wet_degree_sensor":
                        self.DB.create(self.DB.uuid,self.DB.type_data)
                    elif self.DB.type_data=="ir_controller":
                        self.DB.create(self.DB.uuid,self.DB.type_data)
        
        self.mqttc.set_callback(sub_cb)
        self.mqttc.subscribe(b"AIOT_113/AppSend")
        self.screen.display(["NCUE AIOT"])
        time.sleep(1)
        self.status = "loop"
    
    def loop(self):
        if self.cir.receiver != []:
#             print(self.cir.receiver)
            self.cir.receiver = []
        self.dht.routine()
        from file_system import ujson
        self.mqttc.publish(b'AIOT_113/Esp32Send', ujson.dumps({"type":"dht11","uuid":self.DB.read("uid")[1],"humidity":self.dht.hum,"temperature":self.dht.temp}))
        self.mqttc.check_msg()
        self.screen.display(["Hum: "+str(self.dht.hum),"Temp: "+str(self.dht.temp)])
#         self.screen.drawSleepPage()
    
    def switch(self):
        try:
            if self.status == "wifi_not_connected":
                self.setUp()
            elif self.status == "wifi_connecting":
                self.connecting()
            elif self.status == "wifi_connected":
                try:
                    self.wifi_connected()
                except Exception as e:
                    raise Exception("wifi_connected: "+str(e))
            elif self.status == "loop":
                try:
                   self.loop()
                except Exception as e:
                    raise Exception("error on loop"+str(e))
            elif self.status == "ble_mode":
                try:
                    self.ble_setup()
                except:
                    raise Exception("error on status:ble")
        except Exception as e:
            self.status = "error"
            raise Exception("switch: "+str(e))

    def run(self):
        try:
            while True:
                if self.status == "error":
                    break
                self.switch()
        except Exception as e:
            self.status = "wifi_not_connected"
            print(e)
    
m = core(screenOn = True)

m.run()



