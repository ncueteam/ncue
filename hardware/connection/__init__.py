import network
import uasyncio
import time
from file_system import FileSet

sta_if = network.WLAN(network.STA_IF)    

class Network():
    def __init__(self,oled=False):
        self.DB =  FileSet("wifi.json")
        self.oled = oled
        if(oled):
            import oled
            self.screen = oled.OLED()
    
    def getData(self):
        return sta_if.ifconfig()
    
    def isConnected(self):
        return sta_if.isconnected()
    
    def addDefaultWifi(self):
        await self.DB.create("Yunitrish", "0937565253")

    def setUp(self):
        if self.isConnected():
            sta_if.disconnect()
        for key,value in self.DB.database.items():
            if (self.oled):
                self.screen.blank()
                self.screen.centerText(2,"connecting")
                self.screen.centerText(4,"from")
                self.screen.centerText(6,"Database!")
                self.screen.show()
            else:
                print("connecting.. "+key)
            time.sleep(1)
            if self.connector(key,value):
                if(self.oled):
                    self.screen.blank()
                    self.screen.centerText(2,key)
                    self.screen.centerText(4,"connected!")
                    self.screen.show()
                else:
                    print(key+" connected!")
                return True
        if not sta_if.isconnected():
            if(self.oled):
                self.screen.blank()
                self.screen.centerText(2,"connect")
                self.screen.centerText(4,"error!")
                self.screen.show()
            else:
                print("connection error")
            return False
    
    def connector(self,key,value):
        MAX_TRY = 10
        TRY = 0
        sta_if.active(False)
        sta_if.active(True)
        sta_if.connect(key,value)
        if(self.oled):
            self.screen.blank()
            self.screen.centerText(2,"connecting")
            self.screen.centerText(4,key)
            self.screen.show()
        while not sta_if.isconnected():
            uasyncio.sleep_ms(2000)
            TRY += 1
            if(self.oled):
                self.screen.blank()
                self.screen.centerText(2,"connecting")
                self.screen.centerText(4,key)
                self.screen.centerText(6,str(TRY)+" / "+str(MAX_TRY))
                self.screen.show()
            if  TRY > MAX_TRY:
                TRY = 0
                break
            pass
        if not sta_if.isconnected():
            if(self.oled):
                self.screen.blank()
                self.screen.centerText(2,"connecting ")
                self.screen.centerText(4,key)
                self.screen.centerText(6," failed....")
                self.screen.show()
            uasyncio.sleep_ms(2000)
            return False
        else:
            if(self.oled):
                self.screen.blank()
                self.screen.centerText(4,key + " connected!")
                self.screen.show()
            uasyncio.sleep_ms(1000)
            return True
def bootLink():
    net = Network()
    loop = uasyncio.get_event_loop()
    async def main_task():
        await net.setUp()
    try:
        task = loop.create_task(main_task())
        loop.run_forever()
    except KeyboardInterrupt:
        print("Ctrl+C pressed stopping.....")
    finally:
        task.cancel()
        loop.run_until_complete(task)
        loop.close()
