import machine
import uasyncio
import sys
import oled
import connection
import dht11
import ir_system
import web_api
from file_system import FileSet
from umqtt.simple import MQTTClient
from umqtt.aiot import AIOT

#取得總迴圈 
loop = uasyncio.get_event_loop()

global restart_main_task
restart_main_task = False

#紅外線數值
ir = ir_system.IR_IN()
#OLED顯示器
screen = oled.OLED("X")
# DHT11
dht = dht11.Sensor()
# 檔案系統
DB2 =  FileSet("degree_wet.json")
# 網路連線
net = connection.Network(oled=True)
#主程式
async def main_task():
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
        # MQTT
        dht_mqtt = AIOT(uuid+"/dht11")
        await screen.blank()
        await screen.text(0, 2, "Connecting")
        await screen.text(0, 4, "MQTT dht11")
        await screen.show()
        await dht_mqtt.connect()
        while True:
            print(ir.result)
            await web_api.send_ir_data(device_uuid, ir.result)
            await dht_mqtt.wait()
            # DHT
            await dht.wait()
            await dht.detect()
            value = await dht.getMQTTMessage()
            await dht_mqtt.routine(value)
            await DB2.create("degree",value)
            await web_api.sendDHTData(device_uuid, value.split(" ")[0], value.split(" ")[1])
            # OLED
            await screen.blank()
            await screen.drawSleepPage()
            await screen.displayTime()
            await screen.text(64, 4, dht_mqtt.received)
            await screen.show()
    else:
        await uasyncio.sleep_ms(2000)
        await screen.blank()
        await screen.centerText(1, "BLE!")
        await screen.centerText(3, "Connect")
        await screen.centerText(5, "Mode")
        await screen.show()
        import ble
        bt = ble.BLE()
        await uasyncio.sleep_ms(2000)
        await screen.blank()
        await screen.centerText(2, "BLE name")
        await screen.centerText(4, bt.name)
        await screen.show()
        await uasyncio.sleep_ms(2000)
        ble_try = 10
        while ble_try:
            await screen.blank()
            await screen.centerText(2, bt.name)
            await screen.centerText(4, str(11-ble_try)+" / 10")
            await screen.show()
            await uasyncio.sleep_ms(2000)
            if (bt.wifi_added):
                await screen.blank()
                await screen.centerText(4, "wifi added!")
                await screen.show()
                await uasyncio.sleep_ms(2000)
                global restart_main_task
                restart_main_task = True
            if (bt.bt_linked):
                await screen.blank()
                await screen.centerText(4, "bt linked!")
                await screen.show()
                await uasyncio.sleep_ms(2000)
            ble_try-=1

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