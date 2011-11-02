#!/usr/bin/env python
#-*- coding:utf-8 -*-

import socket

HOST='localhost'
PORT=5005

message = raw_input('\nDiginte a mensagem\n')
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(str(message), (HOST, PORT))
