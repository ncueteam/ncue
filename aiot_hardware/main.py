import machine
import uasyncio as asyncio
import sys
from segment7 import Segment7

#初始化
pins = [machine.Pin(i, machine.Pin.OUT) for i in [18,5,25,33,32,19,21,26]]
#計數器
global counter
counter = 0
def count():
    global counter
    counter  = (counter + 1)%10
    return counter
#七段顯示器
s7 = Segment7()
#取得總迴圈
loop = asyncio.get_event_loop()
#主程式
async def main_task():
    while True:
        count()
        await s7.display(pins,str(counter))
#主程式加入總迴圈
task = loop.create_task(main_task())
#關閉相關
try:
    loop.run_forever()
except KeyboardInterrupt:
    print("Ctrl+C pressed. Stopping...")
finally:
    task.cancel()
    loop.run_until_complete(task)
    loop.close()
