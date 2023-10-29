# -*- coding: utf-8 -*-
#test on python 3.4 ,python of lower version  has different module organization.
import http.server
from http.server import HTTPServer, BaseHTTPRequestHandler
import socketserver

PORT = 8080
print("Started serving at port", PORT)

Handler = http.server.SimpleHTTPRequestHandler

Handler.extensions_map={
        '.manifest': 'text/cache-manifest',
        '.html': 'text/html',
        '.png': 'image/png',
        '.jpg': 'image/jpg',
        '': 'application/octet-stream',
    }

httpd = socketserver.TCPServer(("", PORT), Handler)

try:
    httpd.serve_forever()

except KeyboardInterrupt:
    print("\nStopped serving")
    httpd.socket.close()
