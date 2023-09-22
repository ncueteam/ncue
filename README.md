# ncue 彰師大智慧家電系統

## 留言區

>
> 之後會陸續更新
>

## aiot_app

### 網頁端 & 應用程式的部分

#### RD

1. token 登入
2. web api
  
  > 裝置註冊
  >
  > 登入
  >
  > 註冊
  >
  > 裝置更新
  >
  > 偵測資料傳輸
  >

## aiot_hardware

### 硬體的部分
  
  1. 紅外線 app 連結
  2. 陽極鎖
  3. [溫溼度、PM2.5、光感器、rc522....] 等傳感器 MQTT
  4. OLED 連結 MQTT
  5. 電力保存系統

#### IR receiver (紅外線) pinout

| 紅外線感測器 | esp32 |
|-------------|-------|
| VCC | 3.3v |
| GND | GND |
| OUT | GPIO18 |

#### OLED (螢幕) pinout

| OLED | esp32 |
|-|-|
| VCC | 3.3v |
| GND | GND |
| SDA | GPIO22 |
| SCL | GPIO23 |
