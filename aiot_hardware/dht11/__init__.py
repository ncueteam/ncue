import dht
import machine
MAX_CYCLE = 32
DEFAULT_PIN = 14

class Sensor():
    def __init__(self, pin = DEFAULT_PIN) -> None:
        self.program_counter = 0
        self.cycle = 0
        self.sensor = dht.DHT11(machine.Pin(pin))
        self.hum = -1
        self.temp = -1
        
    async def detect(self):
        if (self.cycle >= MAX_CYCLE - 1):
            self.sensor.measure()
            self.hum = self.sensor.humidity()
            self.temp = self.sensor.temperature()

    def getJson(self):
        return {"humidity":self.hum,"temperature":self.temp}

    async def wait(self):
        self.cycle += 1
        if (self.cycle  >= MAX_CYCLE):
            self.cycle = 0