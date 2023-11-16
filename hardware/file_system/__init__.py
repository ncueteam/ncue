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
        self.data = self.load()
        self.save()

    def initialize(self):
        try:
            os.mkdir("/" + self.Folder)
        except OSError as e:
            if e.args[0] != 17:
                raise

    def create(self, key: str, value: str):
        self.data[key] = value
        self.save()
        
    def read(self, key: str) -> tuple[str, str]:
        return key, self.data[key]

    def update(self, key: str, value: str):
        self.data[key] = value
        self.save()

    def delete(self, key: str):
        del self.data[key]
        self.save()

    def list(self):
        return self.data

    def save(self):
        with open("/" + self.Folder + "/" + self.FileName, 'w') as f:
            ujson.dump(self.data, f)

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