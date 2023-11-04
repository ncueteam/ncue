from umqtt.simple import MQTTClient
MAX_CYCLE = 100
MAIN_TOPIC="AIOT_113"
class AIOT():
    def __init__(self,subtopic) -> None:
        self.cycle = 0
        self.topic = MAIN_TOPIC+"/"+subtopic
        self.client = MQTTClient(
            client_id="client",
            keepalive=MAX_CYCLE*2,
            server="test.mosquitto.org",
            ssl=False)
        self.received = "none"
    
    async def connect(self):
        try:
            self.client.connect()
        except:
            return None
        def get_msg(topic, msg):
            self.received = msg
#             print(msg)
        self.client.set_callback(get_msg)
        self.client.subscribe(self.topic)

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
    port = AIOT("services")
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
