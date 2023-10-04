from machine import Pin
from ir_rx import NEC_16

ir_key = {
    0x45: 'UP',
    0x46: 'UP',
    0x47: 'MUTE',
    0x40: 'OK',
    0x44: 'BACK',
    0x43: 'NEXT',
    0x07: 'EQ',
    0x15: 'DOWN',
    0x09: 'PLUS',
    0x16: '1',
    0x19: '2',
    0x0D: '3',
    0x0C: '4',
    0x18: '5',
    0x5E: '6',
    0x08: '7',
    0x1C: '8',
    0x5A: '9',
    0x42: '*',
    0x52: '0',
    0x4A: '#'    
    }

def callback(data, addr, ctrl):
    if data > 0:  # NEC protocol sends repeat codes.
        #print('Data {:02x} Addr {:04x}'.format(data, addr))
        print(ir_key[data])

ir = NEC_16(Pin(23, Pin.IN), callback)