import network
import time
from file_system import FileSet

sta_if = network.WLAN(network.STA_IF)    

class Network():
    def __init__(self,screenMode="console"):
        self.DB =  FileSet("wifi.json")
        import oled
        self.screen = oled.OLED(mode=screenMode)
    
    def getData(self):
        return sta_if.config('essid')
    
    def isConnected(self):
        return sta_if.isconnected()

    def setUp(self):
        if self.isConnected():
            sta_if.disconnect()
        for key,value in self.DB.database.items():
            self.screen.display(["connecting","from","database"])
            time.sleep(1)
            if self.connector(key,value):
                return True
        if not sta_if.isconnected():
            self.screen.display(["connect","error!"])
            return False
    
    def connector(self,key,value):
        MAX_TRY = 10
        TRY = 0
        sta_if.active(False)
        sta_if.active(True)
        sta_if.connect(key,value)
        self.screen.display(["connecting",key])
        while not sta_if.isconnected():
            time.sleep(2)
            TRY += 1
            self.screen.display(["connecting",key,str(TRY)+" / "+str(MAX_TRY)])
            if  TRY > MAX_TRY:
                TRY = 0
                break
            pass
        if not sta_if.isconnected():
            self.screen.display(["connecting",key,"failed...."])
            time.sleep(2)
            return False
        else:
            self.screen.display([key,"connected!"])
            time.sleep(1)
            return True
