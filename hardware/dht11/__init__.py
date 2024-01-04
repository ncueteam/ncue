import dht
import machine
import time
MAX_CYCLE = 32
DEFAULT_PIN = 14

class dht11():
    def __init__(self, pin = DEFAULT_PIN,mode="console",timer=machine.Timer(3)) -> None:
        import oled
        self.screen = oled.OLED(mode=mode)
        self.screen.display(["setting up","dht"])
        self.dht11 = dht.DHT11(machine.Pin(pin))
        
        self.timer = timer
        self.last_ticks = 0
        
        self.hum = -1
        self.temp = -1
        
    def routine(self):
        now = time.ticks_ms()
        if time.ticks_diff(now,self.last_ticks) > 120:
            self.last_ticks = now
            try:
#                 self.screen.display(["getting","dht data"])
                self.dht11.measure()
                self.hum = self.dht11.humidity()
                self.temp = self.dht11.temperature()
            except Exception as e:
#                 print(str(e))
                return
        else:
            pass

    def getJson(self):
        return {"humidity":self.hum,"temperature":self.temp}