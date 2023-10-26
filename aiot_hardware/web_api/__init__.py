import urequests
import ujson

DEFAULT_WEB = "http://frp.4hotel.tw:25580/api/test"

#class WEBAPI():
    #def __init__(self) -> None:
       #self.response = urequests.get(DEFAULT_WEB)
       #print(self.response)
       
    #test = urequests.get(DEFAULT_WEB)

async def run():
    print("post")
    post_data = ujson.dumps({'test': '21234'})
    print(urequests.post("http://frp.4hotel.tw:25580/api/test2", headers = {'content-type': 'application/json'}, data = post_data).text)