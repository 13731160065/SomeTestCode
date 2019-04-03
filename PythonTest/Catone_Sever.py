import socketserver

class Myserver(socketserver.BaseRequestHandler):
	global tremote
	global trobot

	tremote = 0
	trobot = 0

	def handle(self):
		global tremote
		global trobot

		conn = self.request
		conn.sendall(bytes("socket已连接", encoding="utf-8"))
		while True:
			ret_bytes = conn.recv(1024)
			ret_str = str(ret_bytes,encoding="utf-8")

			if ret_str == "q":
				break

			if ret_str.startswith("cmd:"):
				aStr = ret_str.split(":")[1]
				conn.sendall(bytes("服务端执行:"+aStr, encoding="utf-8"))
				continue
			
			if ret_str.startswith("remote:"):
				aStr = ret_str.split(":")[1]
				trobot.sendall(bytes(aStr, encoding="utf-8"))
				continue

			if ret_str.startswith("robot:"):
				aStr = ret_str.split(":")[1]
				tremote.sendall(bytes(aStr, encoding="utf-8"))
				continue

			if ret_str == "newremote":
				tremote = conn
				if trobot:
					tremote.sendall(bytes("遥控已连接，机器人在线", encoding="utf-8"))
				else:
					tremote.sendall(bytes("遥控已连接，机器人离线", encoding="utf-8"))
				continue

			if ret_str == "newrobot":
				trobot = conn
				trobot.sendall(bytes("机器人已连接", encoding="utf-8"))
				if tremote:
					tremote.sendall(bytes("机器人上线", encoding="utf-8"))
				continue

if __name__ == "__main__":
	server = socketserver.ThreadingTCPServer(("192.168.21.5", 8088),Myserver)
	server.serve_forever()
	
