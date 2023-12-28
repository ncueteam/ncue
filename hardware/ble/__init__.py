import ubluetooth
from file_system import FileSet
class BLE():
    def __init__(self,mode="console") -> None:
        import oled
        self.screen = oled.OLED(mode=mode)
        self.name = "esp32 ncue"
        self.ble = ubluetooth.BLE()
        self.ble.active(False)
        self.ble.active(True)
        self.ble.config(mtu=512)
        self.register()
        self.ble.irq(self.handler)
        self.wifi_added = False
        self.bt_linked = False
        self.screen.display(["bluetooth","setting up.."])
    
    def register(self):
        ENV_SERVER_UUID = ubluetooth.UUID(0x9011)
        
        TEM_CHAR_UUID = ubluetooth.UUID(0x9012)
        TEM_CHAR = (TEM_CHAR_UUID, ubluetooth.FLAG_READ | ubluetooth.FLAG_WRITE | ubluetooth.FLAG_NOTIFY,)
        
        HUM_CHAR_UUID = ubluetooth.UUID(0x9013)
        HUM_CHAR = (HUM_CHAR_UUID, ubluetooth.FLAG_READ | ubluetooth.FLAG_WRITE | ubluetooth.FLAG_NOTIFY,)
        
        DEVICE_CHAR_UUID = ubluetooth.UUID(0x9020)
        DEVICE_CHAR = (DEVICE_CHAR_UUID, ubluetooth.FLAG_READ | ubluetooth.FLAG_WRITE | ubluetooth.FLAG_NOTIFY,)

        ENV_SERVER = (ENV_SERVER_UUID, (TEM_CHAR, HUM_CHAR,DEVICE_CHAR),)
        SERVICES = (ENV_SERVER,)

        
        ((self.tem_char, self.hum_char,self.device_char),) = self.ble.gatts_register_services(SERVICES)
        self.screen.display(["bluetooth","broadcasting.."])
        advertise_data0 = bytearray([2,1,6,2,10,16])
        advertise_data1 = bytearray((len(self.name) + 1, 0x09))
        advertise_data2 = bytearray(self.name, 'utf-8')
        self.ble.gap_advertise(100, adv_data= advertise_data0 + advertise_data1 + advertise_data2)
    def handler(self,event,data):
        if event == 1:
            self.screen.display(["bluetooth","connected!"])
            self.bt_linked = True

        elif event == 2:
            self.screen.display(["bluetooth","disconnected!"])
            self.ble.gap_advertise(100, adv_data=bytearray([2,1,6,2,10,8]) + bytearray(
                (len(self.name) + 1, 0x09)) + self.name)
            self.bt_linked = False

        elif event == 3:
            onn_handle, char_handle = data
            buffer = self.ble.gatts_read(char_handle)
            ble_msg = buffer.decode('UTF-8').strip()
            self.screen.display([ble_msg])

#             print(ble_msg)

            arr = ble_msg.split(':')
            key, value = arr[0], arr[1]
            self.uid = ""
            if (key == "id_1"):
                self.uid1 = value
            elif (key == "id_2"):
                self.uid2 = value
                self.fileSet = FileSet(file_name='device_data.json')
                self.fileSet.update("uid", self.uid1+self.uid2)
            elif (key == "ssid"):
                self.ssid = value
            elif (key == "pswd"):
                self.pswd = value
                self.fileSet = FileSet(file_name='wifi.json')
                self.fileSet.update(self.ssid,self.pswd)
                self.wifi_added = True
            return
                
            
            
