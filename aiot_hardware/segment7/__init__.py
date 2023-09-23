import machine
import uasyncio

DEFAULT_PIN = [18,5,25,33,32,19,21,26]
PATTERNS = {
    '.': [0, 0, 0, 0, 0, 0, 0, 1],
    '0': [1, 1, 1, 1, 1, 1, 0, 0],
    '1': [0, 1, 1, 0, 0, 0, 0, 0],
    '2': [1, 1, 0, 1, 1, 0, 1, 0],
    '3': [1, 1, 1, 1, 0, 0, 1, 0],
    '4': [0, 1, 1, 0, 0, 1, 1, 0],
    '5': [1, 0, 1, 1, 0, 1, 1, 0],
    '6': [1, 0, 1, 1, 1, 1, 1, 0],
    '7': [1, 1, 1, 0, 0, 1, 0, 0],
    '8': [1, 1, 1, 1, 1, 1, 1, 0],
    '9': [1, 1, 1, 1, 0, 1, 1, 0]
}

class Segment7():
    PIN_OUTS = []
    def __init__(self, pin:[int] = DEFAULT_PIN) -> None:
        print("initializing segment....")
#         self.PIN_OUTS = [machine.Pin(it, machine.Pin.OUT) for it in pin]
        print("segment initialize finished")
    
    async def flash(self, pin):
        await uasyncio.sleep(1)
        pin.on()
        await uasyncio.sleep(1)
        pin.off()
    
    async def display(self, pins, code):
        for i in range(0,8):
            if (PATTERNS[code][i] == 0):
                pins[i].on()
            else:
                pins[i].off()
        await uasyncio.sleep(1)
        for pin in pins:
            pin.on()




