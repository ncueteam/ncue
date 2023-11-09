import machine
import uasyncio
import oled
import connection
from umqtt.simple import MQTTClient
from umqtt.aiot import AIOT
from file_system import FileSet



loop = uasyncio.get_event_loop()#取得總迴圈

net = connection.Network(oled=True)# 網路連線

DB2 =  FileSet("degree_wet.json")# 檔案系統

screen = oled.OLED()#OLED顯示器

global restart_main_task
restart_main_task = False

#主程式
async def main_task():#主程式
    # 檔案系統
    await DB2.setUp()
    uuid = ""
    try:
        uuid = (await DB2.read("uuid"))[1]
    except Exception as e:
        uuid = await DB2.generate_uuid()
        await DB2.create("uuid",uuid)
        print(e)
    # 載入畫面
    await screen.blank()
    await screen.centerText(4,"NCUE AIOT")
    await screen.show()
    await uasyncio.sleep_ms(100)
    # 網路連線
    is_connected = await net.setUp()
    if (is_connected):
        mqtt = AIOT("AppSend",uuid)
        async def loopor():
            if mqtt.received != "none":
                print(mqtt.received)
                mqtt.received="none"
        while True:
            await loopor()
            await mqtt.wait()
            print(mqtt.received)
            await uasyncio.sleep_ms(100)
    else:
        print("connection error")
        
            
def run():
    try:
        task = loop.create_task(main_task())
        loop.run_forever()
    except KeyboardInterrupt:
        print("Ctrl+C pressed stopping.....")
    finally:
        task.cancel()
        loop.run_until_complete(task)
        loop.close()
if __name__ == '__main__':
    global restart_main_task
    max_try = 3
    while(max_try or restart_main_task):
        run()
        if (restart_main_task):
            max_try = 3
        else:
            max_try-=1
        restart_main_task = False


