/*
*	Author	: RIZAL MUHAMMED [UB3RSiCK] - SLAE-933
*	Title	: Metasploit linux/x86 shellcode analysis
*
*	execve id
*	msfvenom -p linux/x86/exec CMD=id -f c
*/

#include<stdio.h>
#include<string.h>
unsigned char code[] = \
"\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68\x2f\x73\x68\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52\xe8\x03\x00\x00\x00\x69\x64\x00\x57\x53\x89\xe1\xcd\x80";
main()
{
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}

	
