import dht
import machine
MAX_CYCLE = 32
DEFAULT_PIN = 14

class Sensor():
    def __init__(self, pin = DEFAULT_PIN,mode="console") -> None:
        import oled
        self.screen = oled.OLED(mode=mode)
        self.screen.display(["setting up","dht"])
        self.cycle = 0
        self.sensor = dht.DHT11(machine.Pin(pin))
        self.hum = -1
        self.temp = -1
        
    def routine(self):
        self.cycle += 1
        if (self.cycle >= MAX_CYCLE - 1):
            self.screen.display(["getting","dht data"])
            self.sensor.measure()
            self.hum = self.sensor.humidity()
            self.temp = self.sensor.temperature()
            self.cycle = 0

    def getJson(self):
        return {"humidity":self.hum,"temperature":self.temp}