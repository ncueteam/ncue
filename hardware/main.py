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
        self.RDB = file_system.FileSet('remote_data.json')
        
        self.screen.display(["setting up","MQTT!"])
        from umqtt.simple import MQTTClient
        import ubinascii
        self.mqttc = MQTTClient(ubinascii.hexlify(machine.unique_id()), 'test.mosquitto.org', port=1883)
        self.screen.display(["MQTT","connecting......"])
        self.mqttc.connect()
        def sub_cb(topic,msg):
#             print(str(topic,"UTF-8")+","+str(msg,"UTF-8"))
            self.DB.handle_json(msg)
            if(self.DB.uuid==self.DB.read("uid")[1]):
                if self.DB.type=="ir_tx":
                    self.screen.display([self.DB.type,self.DB.protocol,self.DB.data])
#                     dddd = [2891, 2985, 498, 458, 535, 467, 536, 467, 536, 484, 521, 483, 516, 489, 518, 483, 495, 506, 521, 466, 533, 486, 523, 481, 519, 1490, 518, 465, 537, 1488, 519, 1488, 517, 481, 522, 482, 520, 483, 520, 483, 521, 467, 537, 463, 538, 465, 538, 1489, 518, 481, 519, 486, 519, 466, 536, 466, 537, 467, 536, 465, 537, 483, 496, 508, 496, 538, 497, 458, 537, 466, 535, 467, 536, 483, 497, 509, 492, 512, 517, 484, 496, 506, 525, 462, 537, 482, 495, 509, 492, 513, 491]
#                     room2 = [3557, 2389, 588, 1802, 585, 1806, 582, 1808, 582, 1807, 584, 618, 617, 582, 613, 584, 615, 583, 616, 584, 613, 585, 613, 1773, 581, 1810, 579, 1811, 580, 621, 617, 581, 640, 559, 612, 1774, 580, 621, 614, 584, 636, 564, 612, 1774, 580, 1811, 580, 620, 614, 1773, 607, 596, 590, 608, 588, 610, 612, 1900, 432, 644, 612, 1749, 612, 1760, 611, 8638, 3640, 2375, 645, 1745, 644, 1746, 643, 1745, 619, 1774, 617, 581, 606, 592, 642, 556, 645, 554, 582, 614, 611, 588, 638, 1753, 639, 1752, 643, 1798, 590, 558]
#                     room3 = [3562, 2374, 718, 1672, 582, 1807, 581, 1811, 580, 1809, 581, 609, 625, 583, 615, 539, 661, 551, 647, 555, 643, 555, 643, 1772, 581, 1810, 584, 1806, 582, 588, 695, 533, 616, 584, 614, 1774, 581, 591, 642, 555, 644, 584, 615, 1773, 581, 1808, 581, 620, 614, 1774, 581, 589, 647, 582, 615, 555, 643, 1774, 580, 619, 616, 1772, 582, 1790, 581, 8635, 3650, 2397, 581, 1810, 585, 1805, 581, 1808, 585, 1807, 585, 614, 615, 585, 614, 583, 617, 582, 616, 583, 615, 591, 606, 1773, 611, 1781, 580, 1808, 614, 588]
                    net_data = [int(x) for x in self.DB.data[1:-1].split(',')]
                    self.cir.sender.play(net_data)
                    time.sleep(1)
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
            self.cir.receiver = []
        self.dht.routine()
        import ujson
        self.mqttc.publish(b'AIOT_113/Esp32Send', ujson.dumps({"type":"dht11","uuid":self.DB.read("uid")[1],"humidity":self.dht.hum,"temperature":self.dht.temp}))
        self.mqttc.check_msg()
        self.screen.display(["Hum: "+str(self.dht.hum),"Temp: "+str(self.dht.temp)])
#         self.screen.drawSleepPage()
    
    def switch(self):
        self.counter = 0
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
                    self.status = "wifi_not_connected"
                    raise Exception("error on loop: "+str(e))
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



