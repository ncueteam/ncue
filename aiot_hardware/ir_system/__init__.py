import time
from machine import Pin
from ir_rx.nec import NEC_16
from ir_tx.nec import NEC
import uasyncio
import oled
import network

class IR_IN():
    def __init__(self,oled=False):
        self.sendor = NEC(Pin(32, Pin.OUT, value = 0))
        self.receivor = NEC_16(Pin(23, Pin.IN), self.callback)
        self.result = "no data"
#         self.oled = oled
#         if(oled):
#             import oled
#             self.screen = oled.OLED("Z")
#             await self.screen.blank()
#             await self.screen.centerText(4,"test ir")
#             await self.screen.show()
    
    async def wait(self):
        self.toSend = ""
    
    async def send(self,msg):
        self.sendor.transmit(0x0000, int(str(msg, 'UTF-8')))
    
    def callback(self,data, addr, ctrl):
        if data > 0:
            self.result = 'Data {:02x} Addr {:04x}'.format(data, addr)
            print('Data {:02x} Addr {:04x}'.format(data, addr))
    
def test():
    temp = IR_IN()
    screen = oled.OLED("test")
    loop = uasyncio.get_event_loop()
    async def test():
        print("ir_system test")
        while True:
            await screen.blank()
            await screen.centerText(3,temp.result)
            await screen.show()
            await uasyncio.sleep_ms(100)
    try:
        task = loop.create_task(test())
        loop.run_forever()
    except KeyboardInterrupt:
        print("Ctrl+C pressed stopping.....")
    finally:
        task.cancel()
        loop.run_until_complete(task)
        loop.close()
if __name__ == '__main__':
    test()