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
  
#### 待完成

  1. 陽極鎖
  1. 電力保存系統

#### 已完成

  1. 紅外線 app 連結
  1. [溫溼度、PM2.5、光感器、rc522....] 等傳感器 MQTT
  1. OLED 連結 MQTT

#### 韌體安裝

1. 安裝python以及pip
2. 安裝cp10驅動
3. 利用pip安裝esptool
4. 執行 reset.bat 後面加上參數 COMx

#### MQTT topic

| MQTT | AIOT_113 |
|-------------|-------|
| DHT11 | /dht11 |
| IR_transmitter | /IR_tx |
| IR_receiver | /IR_rx |

#### IR receiver (紅外線) pinout

| 紅外線感測器 | esp32 |
|-------------|-------|
| VCC | 3.3v |
| GND | GND |
| OUT | GPIO23 |

#### IR transmitter (紅外線) pinout

| 紅外線發射器 | esp32 |
|-------------|-------|
| VCC | 3.3v |
| GND | GND |
| OUT | GPIO32 |

#### OLED (螢幕) pinout

| OLED | esp32 |
|-|-|
| VCC | 3.3v |
| GND | GND |
| SDA | GPIO21 |
| SCL | GPIO22 |
