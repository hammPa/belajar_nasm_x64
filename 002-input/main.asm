section .data
    inputMsg db "Masukkan String apapun di bawah 20 karakter: ", 0
    inputMsgLen equ $ - inputMsg

section .bss
    buffer resb 20


section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, inputMsg
    mov rdx, inputMsgLen
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 20
    syscall

    mov rdx, rax
    mov rsi, buffer
    mov rax, 1
    mov rdi, 1
    syscall


    mov rax, 60         ; exit
    mov rdi, 0
    syscall
