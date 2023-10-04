import dht
import machine
MAX_CYCLE = 100
DEFAULT_PIN = 14

class Sensor():
    def __init__(self, pin = DEFAULT_PIN) -> None:
        self.program_counter = 0
        self.cycle = 0
        self.sensor = dht.DHT11(machine.Pin(pin))
        self.result = "error reading"
        
    async def detect(self):
        if (self.cycle >= MAX_CYCLE - 1):
            self.sensor.measure()
            self.hum = self.sensor.humidity()
            self.temp = self.sensor.temperature()
            self.result = str(self.hum) + " " + str(self.temp)

    async def getMQTTMessage(self):
        return self.result
    
    async def wait(self):
        self.cycle += 1
        if (self.cycle  >= MAX_CYCLE):
            self.cycle = 0