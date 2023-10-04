import machine
import uasyncio as asyncio
import sys
# from segment7 import Segment7, DEFAULT_PIN
import oled
import sh1106
import network
import dht11
from file_system import FileSet
from umqtt.simple import MQTTClient
from umqtt import aiot

#取得總迴圈 
loop = asyncio.get_event_loop()

#初始化
# pins = [machine.Pin(i, machine.Pin.OUT) for i in DEFAULT_PIN]
i2c = machine.SoftI2C(sda=machine.Pin(21), scl=machine.Pin(22), freq=400000)
sh1106 = sh1106.SH1106_I2C(128, 64, i2c)
 # MQTT
linkor = aiot.AIOT()
#七段顯示器
# s7 = Segment7(pins)
# DHT11
dht = dht11.Sensor()
#OLED顯示器
screen = oled.OLED(sh1106)
# 檔案系統
DB =  FileSet("wifi.json")
DB2 =  FileSet("degree_wet.json")
#主程式
async def main_task():
    # 檔案系統
    await DB.setUp()
    await DB2.setUp()
    # 載入畫面
    await screen.blank()
    await screen.centerText(4,"NCUE AIOT")
    await screen.show()
    await asyncio.sleep_ms(100)
    # 初始化資料系統
#     await DB.create("Yunitrish", "0937565253")
#     await DB.create("V2041", "123456789")
#     await DB.create("studying", "gobacktostudy")
    wifiData = await DB.load()
    #網路連線
    sta_if = network.WLAN(network.STA_IF)    
    async def connector(key,value):
        MAX_TRY = 10
        TRY = 0
        sta_if.active(False)
        sta_if.active(True)
        sta_if.connect(key,value)
        await screen.blank()
        await screen.centerText(2,"connecting")
        await screen.centerText(4,key)
        await screen.show()
        while not sta_if.isconnected():
            await asyncio.sleep_ms(2000)
            TRY += 1
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
            await screen.blank()
            await screen.centerText(4,"connecting " + key + " failed....")
            await screen.show()
            await asyncio.sleep_ms(1000)
            return False
        else:
            await screen.blank()
            await screen.centerText(4,key + " connected!")
            await screen.show()
            await asyncio.sleep_ms(1000)
            return True
    for key,value in DB.Data.items():
        if await connector(key,value):
            break
    # mqtt初始化
    await linkor.connect()

    while True:
        await linkor.wait()
        # DHT
        await dht.wait()
        await dht.detect()
        value = await dht.getMQTTMessage()
        await linkor.routine(value)
        await DB2.create("degree",value)
        # OLED
        await screen.blank()
        await screen.drawSleepPage()
        await screen.displayTime()
        await screen.text(64, 4, linkor.received)
        await screen.show()
        # segment 7
#         await s7.wait()
#         await s7.cycleDisplay()
#         await asyncio.sleep_ms(1)

try:
    task = loop.create_task(main_task())
    loop.run_forever()
except KeyboardInterrupt:
    print("Ctrl+C pressed stopping.....")
finally:
    loop.run_until_complete(task)
    loop.close()