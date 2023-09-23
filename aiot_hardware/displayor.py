import uasyncio
import machine
import segment7


async def flash(led_pin, gap: int):
    led_pin.on()
    await uasyncio.sleep_ms(gap)
    led_pin.off()
    await uasyncio.sleep_ms(gap)
    await uasyncio.create_task(flash(led_pin, gap))


async def show(pin, num):
    for i in num:
        if i == 0:
            pin[count].on()
        elif i == 1:
            pin[count].off()
    return


async def cycle(sleep, to_display):
    for num in to_display:
        print("pattern"+num)
        await uasyncio.create_task(show(default_register, segment7.PATTERNS[num]))
        await uasyncio.sleep_ms(sleep)
    # await uasyncio.create_task(cycle(sleep, to_display))
    return


async def mainLoop(pattern=None, sleep=200, register=None):
    print("loop start")
    global default_register
    if register is not None:
        default_register = [machine.Pin(it, machine.Pin.OUT) for it in register]
    else:
        default_register = [machine.Pin(it, machine.Pin.OUT) for it in segment7.DEFAULT_PIN]
    if pattern is None:
        pattern = ['0', '.', '1', '.', '2', '.', '3', '.', '4', '.', '5', '.', '6', '.', '7', '.', '8', '.', '9', '.']
    sleep = sleep
    await uasyncio.create_task(cycle(sleep, pattern))
    print("loop end")
    return

default_register = []