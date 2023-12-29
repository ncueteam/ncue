import machine
from utime import sleep_ms
class IR():
    def __init__(self,mode="console"):
        import oled
        self.screen = oled.OLED(mode=mode)
        self.screen.display(["setting up","IR....."])
        from ir_system.ir_tx import Player
        self.sender = Player(machine.Pin(32, machine.Pin.OUT, value = 0))
        self.receiver = []
    
    def receive(self):
        import ir_system.ir_rx.acquire
        irq = ir_system.ir_rx.acquire.IR_GET(machine.Pin(23, machine.Pin.IN),display=False)
        while irq.data is None:
            sleep_ms(5)
        irq.close()
        self.receiver = irq.data