import ujson
import os
import uhashlib
import ubinascii
import urandom
DEFAULT_FOLDER = 'database'

class FileSet:
    
    def __init__(self,fileName,databaseFolder = DEFAULT_FOLDER) -> None:
        self.Folder = databaseFolder
        self.FileName = fileName
    
    async def load(self) -> dict[str,str]:
        try:
            with open("/" + self.Folder + "/" + self.FileName, 'r') as f:
                return ujson.load(f)
        except OSError as e:
            if e.args[0] == 2:
                return {}
            else:
                raise
    
    async def save(self):
        with open("/" + self.Folder + "/" + self.FileName, 'w') as f:
            ujson.dump(self.Data, f)
    
    async def setUp(self):
        try:
            os.mkdir("/"+self.Folder)
            self.Data:dict[str,str] = await self.load()
        except OSError as e:
            if e.args[0] != 17: raise
        self.Data:dict[str,str] = await self.load()
    
    async def create(self, key: str, value: str):
        self.Data[key] = value
        await self.save()
    
    
    async def read(self, key: str) -> tuple[str, str]:
        return key, self.Data[key]

    async def update(self, key: str, value: str):
        self.Data[key] = value
        await self.save()

    async def delete(self, key: str):
        del self.Data[key]
        await self.save()

    async def generate_uuid(self):
        uuid_bytes = bytearray(urandom.getrandbits(8) for _ in range(16))
        uuid_bytes[6] = (uuid_bytes[6] & 0x0F) | 0x40
        uuid_bytes[8] = (uuid_bytes[8] & 0x3F) | 0x80
        uuid_str = ubinascii.hexlify(uuid_bytes).decode('utf-8')
        uuid = '-'.join((uuid_str[:8], uuid_str[8:12], uuid_str[12:16], uuid_str[16:20], uuid_str[20:]))
        return uuid
