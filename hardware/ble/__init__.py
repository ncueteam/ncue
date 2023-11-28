import ubluetooth
from file_system import FileSet
class BLE():
    def __init__(self) -> None:
        self.name = "esp32 ncue"
        self.ble = ubluetooth.BLE()
        self.ble.active(False)
        self.ble.active(True)
        self.register()
        self.ble.irq(self.handler)
        self.fileSet = FileSet(file_name='wifi.json')
        self.wifi_added = False
        self.bt_linked = False
    
    def register(self):
        ENV_SERVER_UUID = ubluetooth.UUID(0x9011)
        TEM_CHAR_UUID = ubluetooth.UUID(0x9012)
        HUM_CHAR_UUID = ubluetooth.UUID(0x9013)

        TEM_CHAR = (TEM_CHAR_UUID, ubluetooth.FLAG_READ | ubluetooth.FLAG_WRITE | ubluetooth.FLAG_NOTIFY,)
        HUM_CHAR = (HUM_CHAR_UUID, ubluetooth.FLAG_READ | ubluetooth.FLAG_NOTIFY,)

        ENV_SERVER = (ENV_SERVER_UUID, (TEM_CHAR, HUM_CHAR,),)
        SERVICES = (ENV_SERVER,)

        ((self.tem_char, self.hum_char,),) = self.ble.gatts_register_services(SERVICES)  # 注册服务到gatts

        self.ble.gatts_write(self.tem_char, b'\x06\x08')
        self.ble.gatts_write(self.hum_char, b'\x09\x07')

        # self.name = bytes("NCUE", 'UTF-8')
        print("藍芽開始廣播")
        self.ble.gap_advertise(100,
                               adv_data=b'\x02\x01\x06\x02\x0A\x10' + bytearray((len(self.name) + 1, 0x09)) + self.name)
    def handler(self,event,data):
        if event == 1:
            print("BLE 連接成功")
            self.bt_linked = True

        elif event == 2:
            print("BLE 斷開連結")
            self.ble.gap_advertise(100, adv_data=b'\x02\x01\x06\x02\x0A\x08' + bytearray(
                (len(self.name) + 1, 0x09)) + self.name)
            self.bt_linked = False

        elif event == 3:
            onn_handle, char_handle = data
            buffer = self.ble.gatts_read(char_handle)
            ble_msg = buffer.decode('UTF-8').strip()
            print(ble_msg)

            arr = ble_msg.split(',')
            name = arr[0]
            password = arr[1]
            self.fileSet.update(name, password)
            self.wifi_added = True