import urequests
import ujson

h = ""
t = ""
def sendDHTData(uuid, humidity, temperature):
    global h
    global t
    if(h!=humidity or t!=temperature):
        h = humidity
        t = temperature
        post_data = ujson.dumps({'device_id': uuid,'humidity': humidity, 'temp': temperature,'ctrl_cmd': "dht"})
        print(post_data)
        response = urequests.post("http://frp.4hotel.tw:25580/api/device/info/updateDeviceDatas", data = post_data, headers = {'content-type': 'application/json'})
        if response.status_code == 200:
            response_text = response.text
            print(response_text)
        else:
            print("HTTP_status：", response.status_code)
            print("response: " + response.text)

def send_ir_data(uuid, ir_data):
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
        
def device_control(uuid, ir_data):
    print("device_control")
    post_data = ujson.dumps({'device_id': uuid, 'ctrl_cmd': ir_data})
    print(post_data)
    response = urequests.post("http://frp.4hotel.tw:25580/api/device/info/controlDeviceOK", data = post_data, headers = {'content-type': 'application/json'})
    if response.status_code == 200:
        response_text = response.text
        print(response_text)
    else:
        print("HTTP_status：", response.status_code)
        print("response: " + response.text)
        
def trigger_check(uuid):
    print("trigger_check")
    post_data = ujson.dumps({'device_id': uuid})
    print(post_data)
    response = urequests.post("http://frp.4hotel.tw:25580/api/device/info/triggerOrNot", data = post_data, headers = {'content-type': 'application/json'})
    if response.status_code == 200:
        response_text = response.text
        response_text = ujson.loads(response_text)
        data_list = response_text.get("data", [])
        ctrl_cmd_values = [item.get("ctrl_cmd", "") for item in data_list]
        return ctrl_cmd_values
    else:
        print("HTTP_status：", response.status_code)
        print("response: " + response.text)
