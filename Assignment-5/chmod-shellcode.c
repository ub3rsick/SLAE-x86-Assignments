/*
*	Author	: RIZAL MUHAMMED [UB3RSiCK] - SLAE-933
*	Title	: Metasploit linux/x86 shellcode analysis
*	
*	Set 0600 permission on /tmp/ub3r
*	msfvenom -p linux/x86/chmod FILE=/tmp/ub3r MODE=0600 -f c
*/

#include<stdio.h>
#include<string.h>
unsigned char code[] = \
"\x99\x6a\x0f\x58\x52\xe8\x0a\x00\x00\x00\x2f\x74\x6d\x70\x2f\x75\x62\x33\x72\x00\x5b\x68\x80\x01\x00\x00\x59\xcd\x80\x6a\x01\x58\xcd\x80";
main()
{
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}

	
