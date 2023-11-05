import urequests
import ujson


# async def run():
#     print("post")
#     post_data = ujson.dumps({'test': '21234'})
#     print(urequests.post("http://frp.4hotel.tw:25580/api/test2", headers = {'content-type': 'application/json'}, data = post_data).text)
     
async def sendDHTData(uuid, humidity, temperature):
    post_data = {'device_id': uuid,'humidity': humidity, 'temp': temperature,'ctrl_cmd': "dht"}
    print(post_data)
    response = urequests.post("http://frp.4hotel.tw:25580/api/device/info/updateDeviceDatas", data = post_data, headers = {'content-type': 'application/json'})
    if response.status_code == 200:
        response_text = response.text
        print(response_text)
    else:
        print("HTTP_status：", response.status_code)
        print("response: " + response.text)
    
async def send_ir_data(uuid, ir_data):
    print("send ir data")
    post_data = ujson.dumps({'device_id': uuid, 'ctrl_cmd': ir_data})
    print(post_data)
    response = urequests.post("http://frp.4hotel.tw:25580/api/device/info/updateDeviceDatas", data = post_data, headers = {'content-type': 'application/json'})
    if response.status_code == 200:
        response_text = response.text
        print(response_text)
    else:
        print("HTTP_status：", response.status_code)
        print("response: " + response.text)
