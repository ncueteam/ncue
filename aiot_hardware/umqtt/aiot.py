from umqtt.simple import MQTTClient
import machine
import ubinascii

MAX_CYCLE = 100
MAIN_TOPIC="AIOT_113"

class AIOT():
    def __init__(self,subtopic) -> None:
        self.cycle = 0
        self.topic = MAIN_TOPIC+"/"+subtopic
        self.client = MQTTClient(
            client_id=ubinascii.hexlify(machine.unique_id()),
            keepalive=MAX_CYCLE*2,
            server = "test.mosquitto.org",
            port=1883
            )
        self.received = "none"
    
    async def connect(self):
        try:
            self.client.connect()
        except:
            return None
        def get_msg(topic, msg):
            if msg == b'':
                await self.disconnect()
                await self.connect()
            self.received = msg
            #print(msg)
        self.client.set_callback(get_msg)
        self.client.subscribe(self.topic)
    
    async def disconnect(self):
        try:
            self.client.disconnect()
        except:
            return None
        
    async def wait(self):
        try:
            self.client.check_msg()
        except:
            pass
        self.cycle += 1
        if (self.cycle  >= MAX_CYCLE):
            self.cycle = 0
        
    async def routine(self,content):
        if (self.cycle >= MAX_CYCLE - 1):
            try:
                self.client.publish(self.topic, content)
            except:
                print("error publish")

def test():
    import connection
    import uasyncio
    loop = uasyncio.get_event_loop()
    net = connection.Network()
    port = AIOT("AIOT_113/AppSend")
    async def main_task():
        await net.setUp()
        await port.connect()
        while True:
            port.routine("test")
            if port.received != "none":
                print("# "+port.received)
                port.received = "none"
            uasyncio.sleep(100)
    try:
        task = loop.create_task(main_task())
        loop.run_forever()
    except KeyboardInterrupt:
        print("Ctrl+C pressed stopping.....")
    finally:
        task.cancel()
        loop.run_until_complete(task)
        loop.close()
