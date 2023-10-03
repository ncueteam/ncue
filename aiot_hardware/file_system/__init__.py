import ujson
import os

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