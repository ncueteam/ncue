import network
import uasyncio
from file_system import FileSet

sta_if = network.WLAN(network.STA_IF)    

class Network():
    def __init__(self,oled=False):
        self.DB =  FileSet("wifi.json")
        self.oled = oled
        if(oled):
            import oled
            self.screen = oled.OLED("Y")
    
    
    async def addDefaultWifi(self):
        await self.DB.create("Yunitrish", "0937565253")

    async def setUp(self):
        await self.DB.setUp()
        for key,value in self.DB.Data.items():
            if (self.oled):
                await self.screen.blank()
                await self.screen.centerText(2,"connecting")
                await self.screen.centerText(4,"from")
                await self.screen.centerText(6,"Database!")
                await self.screen.show()
            else:
                print("connecting.. "+key)
            await uasyncio.sleep_ms(1000)
            if await self.connector(key,value):
                if(self.oled):
                    await self.screen.blank()
                    await self.screen.centerText(2,key)
                    await self.screen.centerText(4,"connected!")
                    await self.screen.show()
                else:
                    print(key+" connected!")
                return True
        if not sta_if.isconnected():
            if(self.oled):
                await self.screen.blank()
                await self.screen.centerText(2,"connect")
                await self.screen.centerText(4,"error!")
                await self.screen.show()
            else:
                print("connection error")
            return False
    
    async def connector(self,key,value):
        MAX_TRY = 10
        TRY = 0
        sta_if.active(False)
        sta_if.active(True)
        sta_if.connect(key,value)
        if(self.oled):
            await self.screen.blank()
            await self.screen.centerText(2,"connecting")
            await self.screen.centerText(4,key)
            await self.screen.show()
        while not sta_if.isconnected():
            await uasyncio.sleep_ms(2000)
            TRY += 1
            if(self.oled):
                await self.screen.blank()
                await self.screen.centerText(2,"connecting")
                await self.screen.centerText(4,key)
                await self.screen.centerText(6,str(TRY)+" / "+str(MAX_TRY))
                await self.screen.show()
            if  TRY > MAX_TRY:
                TRY = 0
                break
            pass
        if not sta_if.isconnected():
            if(self.oled):
                await self.screen.blank()
                await self.screen.centerText(2,"connecting ")
                await self.screen.centerText(4,key)
                await self.screen.centerText(6," failed....")
                await self.screen.show()
            await uasyncio.sleep_ms(2000)
            return False
        else:
            if(self.oled):
                await self.screen.blank()
                await self.screen.centerText(4,key + " connected!")
                await self.screen.show()
            await uasyncio.sleep_ms(1000)
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
