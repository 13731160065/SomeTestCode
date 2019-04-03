import socket

obj = socket.socket()
obj.connect(("127.0.0.1", 8088))

ret_bytes = obj.recv(1024)
ret_str = str(ret_bytes, encoding="utf-8")
print(ret_str)
obj.sendall(bytes("newremote", encoding="utf-8"))

while True:
    inp = input("等待输入:")
    if inp == "q":
        obj.sendall(bytes(inp, encoding="utf-8"))
        break
    else:
        obj.sendall(bytes(inp, encoding="utf-8"))
        ret_bytes = obj.recv(1024)
        ret_str = str(ret_bytes, encoding="utf-8")
        print(ret_str)
        

