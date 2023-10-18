import time
from machine import Pin
from ir_rx.nec import NEC_16

class IR_IN():
    def __init__(self):
        self.port = NEC_16(Pin(23, Pin.IN), self.callback)
    def callback(data, addr, ctrl):
        if data > 0:
            print('Data {:02x} Addr {:04x}'.format(data, addr))
