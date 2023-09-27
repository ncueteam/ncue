import machine
import uasyncio

DEFAULT_PIN = [19,18,25,33,32,16,17,26]
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
    def __init__(self, pin_set) -> None:
        print("initializing segment....")
        self.pins = pin_set
        for pin in self.pins:
            pin.on()
        print("segment initialize finished")
    
    async def flash(self,n):
        await uasyncio.sleep_ms(1)
        self.pins[n].on()
        await uasyncio.sleep_ms(1)
        self.pins[n].on()
    
    async def display(self, code):
        for i in range(0,8):
            if (PATTERNS[code][i] == 0):
                self.pins[i].on()
            else:
                self.pins[i].off()
#         for pin in self.pins:
#             pin.on()





