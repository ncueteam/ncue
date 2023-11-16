import ujson
import os


class FileSet:
    Folder = "database"
    FileName = "data.json"

    def __init__(self, folder, file_name):
        self.Folder = folder
        self.FileName = file_name
        self.initialize()
        self.data = self.load()

    def initialize(self):
        try:
            os.mkdir("/" + self.Folder)
        except OSError as e:
            if e.args[0] != 17:
                raise

    def query(self, key: str):
        return key, self.data[key]

    def add(self, key: str, value: str):
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