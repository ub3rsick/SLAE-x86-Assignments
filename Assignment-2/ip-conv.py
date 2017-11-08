#!/usr/bin/env python

'''
Author	: RIZAL MUHAMMED (UB3RSiCK)
Desc	: IP address to Network Byte Order Converter
'''

import sys

if not len(sys.argv) == 2:
	print "Usage: {} ip".format(sys.argv[0])
	sys.exit()


ip = sys.argv[1]
hex_ip = map(lambda x: '0'+x if not len(x) == 2 else x , [hex(int(item))[2:] for item in ip.split('.')[::-1]])
if '00' in hex_ip:
	print "IP Address contains nullbyte: {}".format(hex_ip)
	sys.exit()
print "ip_address: {}\nnetwork_byte_order: {}".format(ip, '0x' + ''.join(hex_ip))
