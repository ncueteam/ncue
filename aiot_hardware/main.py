from json import FirebaseJson
import ufirestore

ufirestore.set_project_id("ncueapp")
raw_doc = ufirestore.get("devices/0aI1Whtihd38FsKevED6")
doc = FirebaseJson.from_raw(raw_doc)

if doc["fields"].exists("FIELD"):
    print("The field value is: %s" % doc["fields"].get("FIELD"))