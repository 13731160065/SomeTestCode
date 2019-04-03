# from socketserver import (TCPServer, BaseRequestHandler)
import socketserver

class Myserver(socketserver.BaseRequestHandler):

	def handle(self):
		conn = self.request
		conn.sendall(bytes("socket已连接", encoding="utf-8"))
		while True:
			ret_bytes = conn.recv(1024)
			ret_str = str(ret_bytes,encoding="utf-8")
			if ret_str == "q":
				break
			if ret_str.startswith("cmd:"):
				aStr = ret_str.split(":")[1]
			 	# outPut = subprocess.check_output(aStr, shell=True)
				conn.sendall(bytes("服务端执行:"+aStr, encoding="utf-8"))
				continue
				
			conn.sendall(bytes("服务端接收到:"+ret_str,encoding="utf-8"))

if __name__ == "__main__":
	server = socketserver.ThreadingTCPServer(("127.0.0.1", 8088),Myserver)
	server.serve_forever()
	
