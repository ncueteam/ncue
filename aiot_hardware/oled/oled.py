import uasyncio as asyncio
from machine import Pin, SoftI2C
import ssd1306

SDA_PIN = 22
SCL_PIN = 23

i2c = SoftI2C(sda=Pin(SDA_PIN), scl=Pin(SCL_PIN))

display = ssd1306.SSD1306_I2C(128, 32, i2c)

async def sleepPage(inix,iniy):
    x = inix
    y = iniy
    ax = 1
    ay = 1
    s = 0
    block = ["#", "@"]
    while True:
        display.fill(1)
        display.text(block[s], x, y,0)
        display.show()
        await asyncio.sleep_ms(20)
        if (x > 128-6 or x < 0):
            ax *= -1
            s = (s+1)%2
        x += ax
        if (y > 32-6 or y < 0):
            ay *= -1
            s = (s+1)%2
        y += ay
async def displayNumbers(num):
    await asyncio.sleep_ms(1)
    display.fill(1)
    display.text(str(num),0,0,0)
    display.show()

async def testPage():
    await asyncio.gather(sleepPage(0,0))