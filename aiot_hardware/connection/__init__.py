import network
import uasyncio
from file_system import FileSet

sta_if = network.WLAN(network.STA_IF)    

class Network():
    def __init__(self):
        self.DB =  FileSet("wifi.json")
    
    async def addDefaultWifi(self):
        await self.DB.create("Yunitrish", "0937565253")

    async def setUp(self):
        await self.DB.setUp()
        for key,value in self.DB.Data.items():
            print("connecting.. "+key)
            if await self.connector(key,value):
                print(key+" connected!")
                break

    async def connector(self,key,value,oled=False):
        MAX_TRY = 10
        TRY = 0
        sta_if.active(False)
        sta_if.active(True)
        sta_if.connect(key,value)
        if(oled):
            await screen.blank()
            await screen.centerText(2,"connecting")
            await screen.centerText(4,key)
            await screen.show()
        while not sta_if.isconnected():
            await uasyncio.sleep_ms(2000)
            TRY += 1
            if(oled):
                await screen.blank()
                await screen.centerText(2,"connecting")
                await screen.centerText(4,key)
                await screen.centerText(6,str(TRY)+" / "+str(MAX_TRY))
                await screen.show()
            if  TRY > MAX_TRY:
                TRY = 0
                break
            pass
        if not sta_if.isconnected():
            if(oled):
                await screen.blank()
                await screen.centerText(4,"connecting " + key + " failed....")
                await screen.show()
            await uasyncio.sleep_ms(1000)
            return False
        else:
            if(oled):
                await screen.blank()
                await screen.centerText(4,key + " connected!")
                await screen.show()
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
