from ir_system.ir_tx import Player
import ujson

from machine import Pin
# pin = (Pin(32, Pin.OUT, value = 0), Pin(32, Pin.OUT, value = 0))

with open('burst.py', 'r') as f:
    lst = ujson.load(f)
ir = Player(Pin(32, Pin.OUT, value = 0))
ir.play(lst)