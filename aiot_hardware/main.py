import machine
import uasyncio
import sys
import oled
import connection
import dht11
import ir_system
from file_system import FileSet
from umqtt.simple import MQTTClient
from umqtt.aiot import AIOT

#取得總迴圈 
loop = uasyncio.get_event_loop()

global restart_main_task
restart_main_task = False

ir = ir_system.IR_IN()
#OLED顯示器
screen = oled.OLED("X")
 # MQTT
dht_mqtt = AIOT("dht11")
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
    if (DB2.read("uuid") ):
        import uhashlib
        import ubinascii
        import urandom
        def generate_uuid():
            uuid_bytes = bytearray(urandom.getrandbits(8) for _ in range(16))
            uuid_bytes[6] = (uuid_bytes[6] & 0x0F) | 0x40
            uuid_bytes[8] = (uuid_bytes[8] & 0x3F) | 0x80
            uuid_str = ubinascii.hexlify(uuid_bytes).decode('utf-8')
            uuid = '-'.join((uuid_str[:8], uuid_str[8:12], uuid_str[12:16], uuid_str[16:20], uuid_str[20:]))
            return uuid
        uuid = generate_uuid()
        await DB2.create("uuid",uuid)
    else:
        uuid = DB2.read("uuid")
    print(uuid)
    # 載入畫面
    await screen.blank()
    await screen.centerText(4,"NCUE AIOT")
    await screen.show()
    await uasyncio.sleep_ms(100)
    # 網路連線
    is_connected = await net.setUp()
    if (is_connected):
        # dht_mqtt初始化
        await screen.blank()
        await screen.text(0, 2, "Connecting")
        await screen.text(0, 4, "MQTT dht11")
        await screen.show()
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