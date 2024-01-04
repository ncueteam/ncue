import ujson
import os
import uhashlib
import ubinascii
import urandom
DEFAULT_FOLDER = 'database'

class FileSet:
    def __init__(self, file_name, folder = DEFAULT_FOLDER):
        self.Folder = folder
        self.FileName = file_name
        self.initialize()
        self.database = self.load()
        self.save()
        self.temp = ""
        self.uuid = "error"

    def initialize(self):
        try:
            os.mkdir("/" + self.Folder)
        except OSError as e:
            if e.args[0] != 17:
                raise

    def create(self, key: str, value: str):
        self.database[key] = value
        self.save()
        
    def read(self, key: str) -> tuple[str, str]:
        try:
            return key, self.database[key]
        except:
            return key, "error"

    def update(self, key: str, value: str):
        self.database[key] = value
        self.save()

    def delete(self, key: str):
        del self.database[key]
        self.save()

    def list(self):
        return self.database

    def save(self):
        with open("/" + self.Folder + "/" + self.FileName, 'w') as f:
            ujson.dump(self.database, f)

    def load(self):
        try:
            with open("/" + self.Folder + "/" + self.FileName, 'r') as f:
                return ujson.load(f)
        except OSError as e:
            if e.args[0] == 2:
                return {}
            else:
                raise
    def generate_uuid(self):
        uuid_bytes = bytearray(urandom.getrandbits(8) for _ in range(16))
        uuid_bytes[6] = (uuid_bytes[6] & 0x0F) | 0x40
        uuid_bytes[8] = (uuid_bytes[8] & 0x3F) | 0x80
        uuid_str = ubinascii.hexlify(uuid_bytes).decode('utf-8')
        uuid = '-'.join((uuid_str[:8], uuid_str[8:12], uuid_str[12:16], uuid_str[16:20], uuid_str[20:]))
        return uuid
    
    def handle_json(self,message):
        try:
            self.temp = ujson.loads(message)
        except:
            pass
        try:
            self.type = self.temp['type']
        except:
            self.type = "error"
        try:
            self.data = self.temp['data']
        except:
            self.data = "error"
        try:
            self.protocol = self.temp['protocol']
        except:
            self.protocol = "error"
        try:
            self.clientID = self.temp['clientID']
        except:
            self.clientID = "error"
        try:
            self.uuid = self.temp['uuid']
        except:
            self.uuid = "error"
        try:
            self.uid = self.temp['uid']
        except:
            self.uid = "error"
        try:
            self.type_data = self.temp['type_data']
        except:
            self.type_data = "error"
        