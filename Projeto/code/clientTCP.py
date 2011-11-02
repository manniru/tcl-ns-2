#!/usr/bin/env python
#-*- encoding utf-8 -*-

# by tcs5
# Simple sample program using TCI/IP protocol with sockets
# Client side

import socket

HOST = 'localhost'
PORT = 50507
connected = True
while connected:
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.connect((HOST, PORT))
	msg = raw_input('\nDigite a operacao \n')
	if (msg == 'close'):
		print 'Connection Closed'
		s.close()
		connected = False
	else:
		s.send(msg)
		data = s.recv(1024)
		print 'Result: ', repr(data)
		s.close()
