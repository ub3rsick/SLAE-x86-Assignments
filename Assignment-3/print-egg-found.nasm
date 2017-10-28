; 
; Author 	: RIZAL MUHAMMED (UB3RSiCK)
; Description 	: Print Egg Found 


global _start
section .text
	_start:
		; print helloworld to screen

		xor eax, eax
		mov al, 0x4			; write syscall
		
		xor ebx, ebx
		mov bl, 0x1			; write to stdout
		
		xor ecx, ecx
		jmp short get_me_buffer_address
			here_is_your_buffer:
				pop ecx		; now ecx will have address of message

		xor edx, edx
		mov dl, 0xd			; param3 how many bytes to write
		int 0x80

		; exit the program

		xor eax, eax			; exit system call - #define __NR_exit 1
		mov al, 0x1
		int 0x80

		get_me_buffer_address:
			call here_is_your_buffer		; when call is executed, address of next instruction is
			message db "EGG IS FOUND", 0xA			; pushed on to the stack


