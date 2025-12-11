section .data
    msg db "hello", 10
    msgLen equ $ - msg

section .bss



section .text
    global _start

_start:
    xor r8, r8          ; pakai register yang baru, jangan samakan dengan x32
    mov r9, 5

.loop_start:
    cmp r8, r9
    jge .loop_end

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msgLen
    syscall

    inc r8
    jmp .loop_start

.loop_end:

    mov rax, 60         ; exit
    mov rdi, 0
    syscall
