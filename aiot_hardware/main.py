import machine
import uasyncio as asyncio
import sys
from segment7 import Segment7, DEFAULT_PIN
import oled
import sh1106
import network
import dht11
from umqtt.simple import MQTTClient
from umqtt import aiot

#初始化
pins = [machine.Pin(i, machine.Pin.OUT) for i in DEFAULT_PIN]
i2c = machine.SoftI2C(sda=machine.Pin(21), scl=machine.Pin(22), freq=400000)
sh1106 = sh1106.SH1106_I2C(128, 64, i2c)
# MQTT
linkor = aiot.AIOT()
#七段顯示器
s7 = Segment7(pins)
# DHT11
dht = dht11.Sensor()
#OLED顯示器
screen = oled.OLED(sh1106)
#取得總迴圈
loop = asyncio.get_event_loop()

#主程式
async def main_task():
    # 載入畫面
    await screen.blank()
    await screen.centerText(4,"NCUE AIOT")
    await screen.show()
    await asyncio.sleep_ms(6000)    
    #網路連線
    sta_if = network.WLAN(network.STA_IF)
    sta_if.active(False)
    sta_if.active(True)
    ssid = 'c&k'
    password = '0423151980'
    sta_if.connect(ssid, password)
    await screen.blank()
    await screen.centerText(3,"connecting")
    await screen.centerText(4, "SSID: " + ssid)
    await screen.centerText(5, "pass: " + password)
    await screen.show()
    
    while not sta_if.isconnected():
        pass
    print("connected")
    # mqtt初始化
    await linkor.connect()
    while True:
        await linkor.wait()
        # DHT
        await dht.wait()
        await dht.detect()
        await linkor.routine(await dht.getMQTTMessage())
        # OLED
        await screen.blank()
        await screen.drawSleepPage()
        await screen.displayTime()
        await screen.show()
        # segment 7
        await s7.wait()
        await s7.cycleDisplay()
        await asyncio.sleep_ms(1)

#主程式加入總迴圈
task = loop.create_task(main_task())
#關閉相關
try:
    loop.run_forever()
except KeyboardInterrupt:
    print("Ctrl+C pressed stopping.....")
finally:
    task.cancel()
    loop.run_until_complete(task)
    loop.close()

