section .data
    msg db "kecil", 0
    msglen equ $-msg

    msg2 db "besar", 0
    msglen2 equ $-msg2

    msg3 db "sama", 0
    msglen3 equ $-msg3

section .bss
    number1 resq 1
    number2 resq 1


section .text
    global _start

_start:
    mov rax, 7000
    mov rbx, 2000
    mov [number1], rax
    mov [number2], rbx

    mov rdi, [number1]
    mov rsi, [number2]
    call isless

    mov rax, 60         ; exit
    mov rdi, 0
    syscall


isless:
    cmp rdi, rsi
    jl .print_less
    jg .print_greater

    mov rsi, msg3
    mov rdx, msglen3
    jmp .out

.print_greater:
    mov rsi, msg2
    mov rdx, msglen2
    jmp .out

.print_less:
    mov rsi, msg
    mov rdx, msglen

.out:
    mov rax, 1
    mov rdi, 1
    syscall
    ret