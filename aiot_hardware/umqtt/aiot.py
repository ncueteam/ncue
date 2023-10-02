from umqtt.simple import MQTTClient
MAX_CYCLE = 100
class AIOT():
    def __init__(self) -> None:
        self.cycle = 0
        self.client = MQTTClient(
            client_id="client",
            keepalive=5,
            server="test.mosquitto.org",
            ssl=False)
    
    async def connect(self):
        self.client.connect()
        def get_msg(topic, msg):
            print(msg)
        self.client.set_callback(get_msg)
        self.client.subscribe("NCUEMQTT")

    async def wait(self):
        self.cycle += 1
        if (self.cycle  >= MAX_CYCLE):
            self.cycle = 0
        
    async def routine(self,content):
        if (self.cycle >= MAX_CYCLE - 1):
            self.client.publish("NCUEMQTT", content)
