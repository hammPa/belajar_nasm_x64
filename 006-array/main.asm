section .data
    newline db 10

    str1 db "hello", 0
    str2 db "world", 0
    str3 db "cuy", 0
    
    arr_of_str:
        dq str1
        dq str2
        dq str3

    arrlen dq 3

section .bss


section .text
    global _start

_start:
    xor r8, r8
    mov r9, [arrlen]

.loop_arr:
    cmp r8, r9
    jge .exit_loop_arr

    ; ambil string tiap index, ambil panjangnya
    mov rdi, [arr_of_str + r8 * 8]
    call strlen
    mov rdx, rax



    ; print
    mov rax, 1
    mov rdi, 1
    mov rsi, [arr_of_str + r8 * 8]
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r8
    jmp .loop_arr

.exit_loop_arr:

    mov rax, 60         ; exit
    mov rdi, 0
    syscall



; --------------------------------------------- STRLEN --------------------------------------------- 
strlen:
    xor rax, rax

.count:
    cmp byte [rdi + rax], 0
    je .exit_count

    inc rax
    jmp .count

.exit_count:

    ret