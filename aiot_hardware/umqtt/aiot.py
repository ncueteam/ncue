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
        self.client.check_msg()
        self.cycle += 1
        if (self.cycle  >= MAX_CYCLE):
            self.cycle = 0
        
    async def routine(self,content):
        if (self.cycle >= MAX_CYCLE - 1):
            self.client.publish(self.topic, content)
