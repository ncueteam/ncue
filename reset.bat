esptool -p com9 erase_flash
esptool --chip esp32 -p COM9 write_flash -z 0x1000 esp32_ota_1.20.0.bin