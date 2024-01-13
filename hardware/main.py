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
        self.dht = dht11.dht11(mode="oled")
    
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
        import comute
        self.com = comute.Comute(mode="oled",cir=self.cir)
        self.screen.display(["NCUE AIOT"])
        time.sleep(1)
        self.status = "loop"
    
    def loop(self):
        if self.cir.receiver != []:
            self.cir.receiver = []
        self.dht.routine()
        self.com.routine(self.dht)
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



