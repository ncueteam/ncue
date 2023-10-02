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
DEFAULT_BUFFER = [str(i) for i in range(0,10)]
MAX_CYCLE = 20

class Segment7():
    def __init__(self, pin_set, to_display = DEFAULT_BUFFER) -> None:
        self.pins = pin_set
        self.program_counter = 0
        self.cycle = 0
        self.display_buffer = to_display
        self.cycle = False
        for pin in self.pins:
            pin.on()
    
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

    async def wait(self):
        self.cycle += 1
        if (self.cycle  >= MAX_CYCLE):
            self.program_counter = (self.program_counter+1)%10
            self.cycle = 0

    async def cycleDisplay(self):
        for i in range(0,8):
            if (PATTERNS[self.display_buffer[self.program_counter]][i] == 0):
                self.pins[i].on()
            else:
                self.pins[i].off()
        





