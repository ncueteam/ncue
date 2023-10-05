# from machine import Pin
# from ir_tx import NEC
# nec = NEC(Pin(23, Pin.OUT, value = 0))
# #nec.transmit(<addr>, <data>)

from machine import Pin
from ir_tx.nec import NEC
nec = NEC(Pin(32, Pin.OUT, value = 0))
nec.transmit(1, 2)  # address == 1, data == 2