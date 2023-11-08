esptool -p %1 erase_flash
esptool --chip esp32 -p %1 write_flash -z 0x1000 esp32_cam.bin