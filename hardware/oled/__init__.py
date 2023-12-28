import uasyncio as asyncio
import machine
import oled.sh1106
import uasyncio

I2C = machine.SoftI2C(sda=machine.Pin(21), scl=machine.Pin(22), freq=400000)
SH1106 = oled.sh1106.SH1106_I2C(128, 64, I2C)

class OLED():
    
    def __init__(self,mode="oled") -> None:
        self.screen = SH1106
        self.x = 0
        self.y = 0
        self.ax = 1
        self.ay = 1
        self.count = 0
        self.s = 0
        self.accumulation = 0
        self.sleep_page = [0,0,64.64]
        self.mode = mode

    def display(self,data:[str]):
        if self.mode=="oled":
            self.blank()
            if len(data) == 1:
                self.centerText(3,data[0])
            elif len(data)==2:
                self.centerText(2,data[0])
                self.centerText(4,data[1])
            elif len(data)==3:
                self.centerText(1,data[0])
                self.centerText(3,data[1])
                self.centerText(5,data[2])
            elif len(data)==4:
                self.centerText(0,data[0])
                self.centerText(2,data[1])
                self.centerText(4,data[2])
                self.centerText(6,data[2])
            self.show()
        elif self.mode=="console":
            for item in data:
                print(item)

    def blank(self):
        self.screen.sleep(False)
        self.screen.fill(1)
    
    def test(self,num):
        self.screen.sleep(False)
        self.screen.fill(1)
        self.screen.text('Testing '+str(num), 0, 0, 0)

    def getAccumulation(self):
        temp = self.accumulation
        self.accumulation = 0
        return temp

    def displayTime(self):
        self.screen.text(str(self.accumulation),64-8*len(str(self.accumulation)),0,0)
        
    def centerText(self, line, content):
        self.screen.text(content, 64-len(content)*4, 8*line, 0)

    def text(self, x, y, content):
        self.screen.text(content, x, 8*y, 0)

    def drawSleepPage(self):
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
        
    def show(self):
        self.screen.show()
        
    def type(self,line,content):
        self.screen.sleep(False)
        self.screen.fill(1)
        self.screen.text(content, 64-len(content)*4, 8*line, 0)
        self.screen.show()

def test():
    screen = OLED()
    def main_task():
        screen.blank()
        screen.centerText(3,"test for oled")
        screen.show()
    main_task()
if __name__ == "__main__":
    test()