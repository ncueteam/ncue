from ir_system.ir_rx.acquire import test
import ujson

lst = test()  # May report unsupported or unknown protocol
with open('burst.py', 'w') as f:
    ujson.dump(lst, f)