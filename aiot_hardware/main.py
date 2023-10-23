import machine
import uasyncio as asyncio
import sys
# from segment7 import Segment7, DEFAULT_PIN
import oled
import connection
import dht11
from file_system import FileSet
from umqtt.simple import MQTTClient
from umqtt.aiot import AIOT

#取得總迴圈 
loop = asyncio.get_event_loop()

#初始化
# pins = [machine.Pin(i, machine.Pin.OUT) for i in DEFAULT_PIN]
# i2c = machine.SoftI2C(sda=machine.Pin(21), scl=machine.Pin(22), freq=400000)
# sh1106 = oled.sh1106.SH1106_I2C(128, 64, i2c)
 # MQTT
dht_mqtt = AIOT("dht11")
#七段顯示器
# s7 = Segment7(pins)
# DHT11
dht = dht11.Sensor()
#OLED顯示器
screen = oled.OLED("X")
# 檔案系統
DB2 =  FileSet("degree_wet.json")
# 網路連線
net = connection.Network()
#主程式
async def main_task():
    # 檔案系統
    await DB2.setUp()
    # 載入畫面
    await screen.blank()
    await screen.centerText(4,"NCUE AIOT")
    await screen.show()
    await asyncio.sleep_ms(100)
    # 網路連線
    await net.setUp()
    
    # dht_mqtt初始化
    await dht_mqtt.connect()

    while True:
        await dht_mqtt.wait()
        # DHT
        await dht.wait()
        await dht.detect()
        value = await dht.getMQTTMessage()
        await dht_mqtt.routine(value)
        await DB2.create("degree",value)
        # OLED
        await screen.blank()
        await screen.drawSleepPage()
        await screen.displayTime()
        await screen.text(64, 4, dht_mqtt.received)
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