import uasyncio as asyncio
import machine

class OLED():
    
    def __init__(self, screen_set) -> None:
        print("initializing oled....")
        self.screen = screen_set
        self.x = 0
        self.y = 0
        self.ax = 1
        self.ay = 1
        self.count = 0
        self.s = 0
        self.accumulation = 0
        print("oled initialize finished")

    async def blank(self):
        self.screen.sleep(False)
        self.screen.fill(1)
    
    async def test(self,num):
        self.screen.sleep(False)
        self.screen.fill(1)
        self.screen.text('Testing '+str(num), 0, 0, 0)

    async def getAccumulation():
        temp = self.accumulation
        self.accumulation = 0
        return temp

    async def displayTime(self):
        self.screen.text(str(self.accumulation),128-8*len(str(self.accumulation)),0,0)

    async def drawSleepPage(self):
        block = ["#", "@"]
        self.screen.sleep(False)
        self.screen.text(block[self.s], self.x, self.y,0)
        if (self.x > 128-6 or self.x < 0):
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
