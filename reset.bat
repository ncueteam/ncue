esptool -p %1 erase_flash
esptool --chip esp32 -p %1 write_flash -z 0x1000 esp32_ota_1.20.0.bin