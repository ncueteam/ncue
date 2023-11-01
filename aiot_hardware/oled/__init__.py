import uasyncio as asyncio
import machine
import oled.sh1106
import uasyncio

I2C = machine.SoftI2C(sda=machine.Pin(21), scl=machine.Pin(22), freq=400000)
SH1106 = sh1106.SH1106_I2C(128, 64, I2C)

class OLED():
    
    def __init__(self) -> None:
        self.screen = SH1106
        self.x = 0
        self.y = 0
        self.ax = 1
        self.ay = 1
        self.count = 0
        self.s = 0
        self.accumulation = 0
        self.sleep_page = [0,0,64.64]

    async def blank(self):
        self.screen.sleep(False)
        self.screen.fill(1)
    
    async def test(self,num):
        self.screen.sleep(False)
        self.screen.fill(1)
        self.screen.text('Testing '+str(num), 0, 0, 0)

    async def getAccumulation(self):
        temp = self.accumulation
        self.accumulation = 0
        return temp

    # async def sleepPositons(self, pos:str) -> list[int]:
    #     if pos == "end":
    #         return [self.sleep_page[2],self.sleep_page[3]]
    #     elif pos == "start":
    #         return [self.sleep_page[0], self.sleep_page[1]]
    #     elif pos == "center":
    #         return [(self.sleep_page[0]+self.sleep_page[2])/2, (self.sleep_page[0]+self.sleep_page[1])/2 ]
    #     else:
    #         return [0, 0]
        


    async def displayTime(self):
        self.screen.text(str(self.accumulation),64-8*len(str(self.accumulation)),0,0)
        
    async def centerText(self, line, content):
        self.screen.text(content, 64-len(content)*4, 8*line, 0)

    async def text(self, x, y, content):
        self.screen.text(content, x, 8*y, 0)

    async def drawSleepPage(self):
        block = ["#", "@"]
        self.screen.sleep(False)
        self.screen.text(block[self.s], self.x, self.y,0)
        if (self.x > 64-6 or self.x < 0):
            self.ax *= -1
            self.accumulation += 1
            self.s = (self.s+1)%2
        self.x += self.ax
        if (self.y > 64-8 or self.y < 0):
            self.ay *= -1
            self.accumulation += 1
            self.s = (self.s+1)%2
        self.y += self.ay
        
    async def show(self):
        self.screen.show()
        
    def type(self,line,content):
        self.screen.sleep(False)
        self.screen.fill(1)
        self.screen.text(content, 64-len(content)*4, 8*line, 0)
        self.screen.show()

def test():
    screen = OLED()
    loop = uasyncio.get_event_loop()
    async def main_task():
        await screen.blank()
        await screen.centerText(3,"test for oled")
        await screen.show()
    try:
        task = loop.create_task(main_task())
        loop.run_forever()
    except KeyboardInterrupt:
        print("Ctrl+C pressed stopping.....")
    finally:
        task.cancel()
        loop.run_until_complete(task)
        loop.close()