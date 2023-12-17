import uasyncio
import time
import connection
import web_api
# connection.bootLink()
# 網路連線
net = connection.Network(oled=False)
global status
status = "wifi_not_connected"

#file_system
import file_system
DB = file_system.FileSet("device_data.json")

#uuid
uuid = ""
try:
    uuid = (DB.read("uuid"))[1]
except Exception as e:
    uuid = DB.generate_uuid()
    DB.create("uuid",uuid)
    print(e)

# IR_transmitter
from ir_system.ir_tx.nec import NEC
from machine import Pin
ir_tx = NEC(Pin(32, Pin.OUT, value = 0))

def ir_tx_callback(uuid, ir_result):
    if ir_result:
        print("*"+ir_result)
        data = ir_result.split(' ')
        ir_tx.transmit(0x0000, int(data[1]))
        web_api.device_control(uuid, ir_result)

# IR_receiver
global ir_data
global ir_addr
ir_data = 0
ir_addr = 0
def ir_callback(data, addr, ctrl):
    global ir_data
    global ir_addr
    if data > 0:
        ir_data = data
        ir_addr = addr
        ir_result = 'Data {:02x} Addr {:04x}'.format(data, addr)
        print(ir_result)
        web_api.send_ir_data(uuid, ir_result)
        ir_data = 0
        ir_addr = 0
        
from ir_system.ir_rx.nec import NEC_16
ir_rx = NEC_16(Pin(23, Pin.IN), ir_callback)

#DHT11
import dht11
dht = dht11.Sensor()

def sub_cb(topic,msg):
        print(str(topic,"UTF-8")+","+str(msg,"UTF-8"))
        DB.handle_json(msg)
#         print(DB.type)
#         print(DB.clientID)
#         print(DB.protocol)
#         print(DB.data)
#         if(DB.clientID=="N0UACuslmEQpDjrJCpaakwsWaLB3"):

        if(DB.type=="ir_tx"):
                if(DB.protocol=="NEC8"):
                    ir_tx.transmit(0x0000, int(DB.data))
                if(DB.protocol=="NEC16"):
                    ir_tx.transmit(0x0000, int(DB.data))
                    #print("ir_tx:"+DB.data)
#         else if(DB.type=="ir_rx"):
#                 global ir_data
#                 if(DB.protocol=="NEC16"):
#                     if ir_data >= 0:
#                     print(ir_data)
        if(DB.type=="register_device"):
            if(DB.type_data=="switch"):
                DB.create(DB.uuid,DB.type_data)
            elif(DB.type_data=="bio_device"):
                DB.create(DB.uuid,DB.type_datadata)
            elif(DB.type_data=="slide_device"):
                DB.create(DB.uuid,DB.type_data)
            elif(DB.type_data=="wet_degree_sensor"):
                DB.create(DB.uuid,DB.type_data)
            elif(DB.type_data=="ir_controller"):
                DB.create(DB.uuid,DB.type_data)
                        
def link():
    print("link")

global attempt

def main():
    global status
    global attempt
    count = 0
    if status == "wifi_not_connected":
        net.setUp()
        status = "wifi_connecting"
        attempt = 0
    elif status == "wifi_connecting":
        if attempt > 2: status = "ble_mode"
        else:
            print("["+str(attempt)+"]connecting")
            if net.isConnected():
                print("connected "+str(net.getData()))
                status = "wifi_connected"
            else:
                time.sleep(5)
                attempt+=1
        
    elif (status == "wifi_connected"):
        import oled
        screen = oled.OLED()#OLED顯示器
        print("start!")
        from umqtt.simple import MQTTClient
        import machine
        import ubinascii
        from file_system import ujson
    
        mqClient0 = MQTTClient(ubinascii.hexlify(machine.unique_id()), 'test.mosquitto.org')
        mqClient0.connect()
        mqClient0.set_callback(sub_cb)
        mqClient0.subscribe(b"AIOT_113/AppSend")
    
        
        screen.blank()
        screen.centerText(4,"NCUE AIOT")
        screen.show()
        
        status = "loop"
#         while True:
#             dht.wait()
#             dht.detect()
#     #        mqClient0.routine(ujson.dumps({"type":"dht11","uuid":uuid,"humidity":dht.hum,"temperature":dht.temp}))
#             queue = {"type":"dht11","uuid":'',"humidity":dht.hum,"temperature":dht.temp};
#             mqClient0.publish(b'AIOT_113/Esp32Send', ujson.dumps(queue))
#             mqClient0.check_msg()
#             
#             screen.blank()
#             screen.drawSleepPage()
#             screen.displayTime()
#     #         screen.text(64, 3, ir.result)
#             screen.text(64, 5, str(dht.hum)+" "+str(dht.temp))
#             screen.show()
#     #         ir.send("0xff")
    
#         mqClient0.disconnect()
    elif status == "loop":
        try:
            print("1")
            
        while True:
            count += 1
            if(count == 100):
                trigger = web_api.trigger_check(uuid)
                if trigger:
                    for ctrl_cmd in trigger:
                        ir_tx_callback(uuid,ctrl_cmd)
                count = 0
            dht.wait()
            dht.detect()
            web_api.sendDHTData(uuid, str(dht.hum), str(dht.temp))
    #        mqClient0.routine(ujson.dumps({"type":"dht11","uuid":uuid,"humidity":dht.hum,"temperature":dht.temp}))
            mqClient0.publish(b'AIOT_113/Esp32Send', ujson.dumps({"type":"dht11","uuid":DB.read("uuid")[1],"humidity":dht.hum,"temperature":dht.temp}))
            mqClient0.check_msg()
            
            screen.blank()
            screen.drawSleepPage()
            screen.displayTime()
    #         screen.text(64, 3, ir.result)
            screen.text(64, 5, str(dht.hum)+" "+str(dht.temp))
            screen.show()
    except:
            status = "wifi_not_connected"
#             mqClient0.disconnect()

    elif status == "ble_mode":
        time.sleep(2)
        screen.blank()
        screen.centerText(1, "BLE!")
        screen.centerText(3, "Connect")
        screen.centerText(5, "Mode")
        screen.show()
        import ble
        bt = ble.BLE()
        time.sleep(2)
        screen.blank()
        screen.centerText(2, "BLE name")
        screen.centerText(4, bt.name)
        screen.show()
        time.sleep(2)
        ble_try = 10
        while ble_try:
            screen.blank()
            screen.centerText(2, bt.name)
            screen.centerText(4, str(11-ble_try)+" / 10")
            screen.show()
            time.sleep(2)
            if (bt.wifi_added):
                screen.blank()
                screen.centerText(4, "wifi added!")
                screen.show()
                time.sleep(2)
                global restart_main_task
                restart_main_task = True
                status = "wifi_not_connected"
                main()
            if (bt.bt_linked):
                screen.blank()
                screen.centerText(4, "bt linked!")
                screen.show()
                time.sleep(2)
            ble_try-=1
    main()

main()
