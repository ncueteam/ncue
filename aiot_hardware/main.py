# from json import FirebaseJson
# import ufirestore

# ufirestore.set_project_id("ncueapp")
# raw_doc = ufirestore.get("devices/0aI1Whtihd38FsKevED6")
# doc = FirebaseJson.from_raw(raw_doc)

# if doc["fields"].exists("FIELD"):
#     print("The field value is: %s" % doc["fields"].get("FIELD"))
# from ir_rx.acquire import test
# test()

from machine import Pin, SoftI2C
import ssd1306

SDA_PIN = 22
SCL_PIN = 23

i2c = SoftI2C(sda=Pin(SDA_PIN), scl=Pin(SCL_PIN))

display = ssd1306.SSD1306_I2C(128,32,i2c)

value = 0

display.fill(value)
display.text('1',0,0)
display.text('2',0,10)
display.text('3',0,20)
display.text('4',0,30)
display.show()