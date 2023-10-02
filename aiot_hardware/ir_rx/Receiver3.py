from machine import Pin
from machine import Timer
from ir_rx import NEC_16


def ir_callback(data, addr, ctrl):
    global ir_data
    global ir_addr
    if data > 0:
        ir_data = data
        ir_addr = addr
        print('Data {:02x} Addr {:04x}'.format(data, addr))
            
def timer_callback(timer):
    led.value( not led.value() )        

ir = NEC_16(Pin(23, Pin.IN), ir_callback)
led = Pin(2, Pin.OUT)
tim0 = Timer(0)
isLedBlinking = False
ir_data = 0
ir_addr = 0

while True:
    if ir_data > 0:
        if ir_data == 0x16:   # 1
            led.value(0)
            if isLedBlinking==True:
                tim0.deinit()
                isLedBlinking = False
        elif ir_data == 0x19: # 2
            led.value(1)
            if isLedBlinking==True:
                tim0.deinit()
                isLedBlinking = False
        elif ir_data == 0x0D: # 3
            isLedBlinking = True
            tim0.init(period=500,
                      mode=Timer.PERIODIC,
                      callback=timer_callback)
        ir_data = 0