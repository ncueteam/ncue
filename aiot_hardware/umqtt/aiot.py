from umqtt.simple import MQTTClient
MAX_CYCLE = 100
class AIOT():
    def __init__(self) -> None:
        self.cycle = 0
        self.client = MQTTClient(
            client_id="client",
            keepalive=MAX_CYCLE,
            server="test.mosquitto.org",
            ssl=False)
        self.received = "not yet!"
    
    async def connect(self):
        self.client.connect()
        def get_msg(topic, msg):
            self.received = msg
#             print(msg)
        self.client.set_callback(get_msg)
        self.client.subscribe("NCUEMQTT")

    async def wait(self):
        self.client.check_msg()
        self.cycle += 1
        if (self.cycle  >= MAX_CYCLE):
            self.cycle = 0
        
    async def routine(self,content):
        if (self.cycle >= MAX_CYCLE - 1):
            self.client.publish("NCUEMQTT", content)
