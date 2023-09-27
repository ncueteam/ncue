import machine
import uasyncio as asyncio
import sys
from segment7 import Segment7, DEFAULT_PIN
import oled
import sh1106
import network
from umqtt.simple import MQTTClient

#初始化
pins = [machine.Pin(i, machine.Pin.OUT) for i in DEFAULT_PIN]
i2c = machine.SoftI2C(sda=machine.Pin(21), scl=machine.Pin(22), freq=400000)
scn1106 = sh1106.SH1106_I2C(128, 64, i2c)
#mqtt
# client = MQTTClient(
#     client_id="client",
#     keepalive=5,
#     server="test.mosquitto.org",
#     ssl=False)
# client.connect()
# def get_msg(topic, msg):
#     print(msg)
# client.set_callback(get_msg)
# client.subscribe("NCUEMQTT")
#七段顯示器
s7 = Segment7(pins)
#OLED顯示器
screen = oled.OLED(scn1106)
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
    ssid = '302'
    password = '0937565253'
    sta_if.connect(ssid, password)
    await screen.blank()
    await screen.centerText(3,"connecting")
    await screen.centerText(4, "SSID: " + ssid)
    await screen.centerText(5, "pass: " + password)
    await screen.show()
    
    while not sta_if.isconnected():
        pass
    print("connected")
    
    while True:
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

