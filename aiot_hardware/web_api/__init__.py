import urequests

DEFAULT_WEB = "http://frp.4hotel.tw:25580/"

class WEBAPI():
    def __init__(self, web) -> None:
       self.response = urequests.post(web, data = "some dummy content")