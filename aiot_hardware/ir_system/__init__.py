import time
from machine import Pin
from ir_rx.nec import NEC_16
from ir_tx.nec import NEC
import uasyncio
import oled
import network

class IR_IN():
    def __init__(self,SCN=False,callback=None):
        self.sendor = NEC(Pin(32, Pin.OUT, value = 0))
        self.receivor = NEC_16(Pin(23, Pin.IN), self.callback)
        self.result = "no data"
        self.onReceived = callback
#         self.oled = SCN
#         if(self.oled):
#             import oled
#             self.screen = oled.OLED("Z")
#             await self.screen.blank()
#             await self.screen.centerText(4,"test ir")
#             await self.screen.show()
    
    async def wait(self):
        self.toSend = ""
        if (self.onReceived != None):
            self.onReceived
    
    async def send(self,msg):
        self.sendor.transmit(0x0000, int(str(msg, 'UTF-8')))
        print("msg:"+msg)
    def callback(self,data, addr, ctrl):
        if (self.onReceived != None):
            self.onReceived
        if data >=0:
            self.result = 'Data {:02x} Addr {:04x}'.format(data, addr)
            print('Data {:02x} Addr {:04x}'.format(data, addr))
    
def test():
    import umqtt.aiot
    import oled
#     temp = IR_IN(SCN=True)
    def clr():
        print("CLR")
    temp = IR_IN(callback=clr)
    screen = oled.OLED()
    loop = uasyncio.get_event_loop()
    async def main():
        count = 0
        while True: 
            await temp.wait()
            await screen.blank()
            count=(count+1)%8
            await screen.centerText(count,"#")
            await screen.centerText(3,temp.result)
            await screen.show()
            await temp.send("0x02")
            await uasyncio.sleep_ms(100)
    try:
        task = loop.create_task(main())
        loop.run_forever()
    except KeyboardInterrupt:
        print("Ctrl+C pressed stopping.....")
    finally:
        task.cancel()
        loop.run_until_complete(task)
        loop.close()
if __name__ == '__main__':
    import connection
    connection.bootLink()
    test()