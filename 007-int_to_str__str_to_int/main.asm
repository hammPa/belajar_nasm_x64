section .data
    doneMsg db "Done", 10
    doneMsgLen equ $ - doneMsg

    str_of_88 db "88", 0

section .bss
    str_of_int resb 32
    int_from_str resq 1


section .text
    global _start

_start:
    ; --------------------------------------------- JADIKAN ANGKA 8 STR ---------------------------------------------
    mov rdi, 8
    mov rsi, str_of_int
    call int_to_str

    ; --------------------------------------------- PRINT ANGKA 8 ---------------------------------------------
    mov rax, 1
    mov rdi, 1
    mov rsi, str_of_int
    mov rdx, 32
    syscall

    ; --------------------------------------------- JADIKAN STRING 8 DARI VARIABEL MENJADI INT ---------------------------------------------
    mov rdi, str_of_88
    call str_to_int
    mov [int_from_str], rax

    ; --------------------------------------------- TAMBAHKAN 10 ---------------------------------------------
    mov rax, [int_from_str]
    add rax, 10
    
    ; --------------------------------------------- JADIKAN HASILNYA STRING ---------------------------------------------
    mov rdi, rax
    mov rsi, str_of_int
    call int_to_str

    ; --------------------------------------------- PRINT HASIL JUMLAH ---------------------------------------------
    mov rax, 1
    mov rdi, 1
    mov rsi, str_of_int
    mov rdx, 32
    syscall

    ; --------------------------------------------- UBAH STRING 000008 MENJADI INT 8 LALU PRINT HASIL---------------------------------------------
    mov rdi, str_of_int
    call str_to_int
    add rax, 33

    mov rdi, rax
    mov rsi, str_of_int
    call int_to_str

    mov rax, 1
    mov rdi, 1
    mov rsi, str_of_int
    mov rdx, 32
    syscall


    mov rax, 60         ; exit
    mov rdi, 0
    syscall




int_to_str:
    mov rax, rdi
    ; posisi terakhir str
    mov r8, 31
    mov byte [rsi + r8], 0
    dec r8

.loop_int_to_str:
    ; pembagian, rax base dan hasil, rdx sisa bagi, r64 apapun pembagi
    xor rdx, rdx
    mov rcx, 10
    div rcx

    add dl, '0'
    mov [rsi + r8], dl          ; masukkan tiap index dari blkg
    dec r8
    test rax, rax
    jnz .loop_int_to_str

    ret



str_to_int:
    xor rax, rax
    mov r8, 0                   ; index
    mov rcx, 10                 ; penbagi

.loop_str_to_int:
    movzx r11, byte [rdi + r8]  ; ambil tiap karakter
    test r11, r11
    je .exit

    sub r11, '0'
    imul rax, rax, 10                     ; rax = rax * rcx
    add rax, r11

    inc r8
    jmp .loop_str_to_int

.exit:
    push rax
    
    mov rax, 1
    mov rdi, 1
    mov rsi, doneMsg
    mov rdx, doneMsgLen
    syscall

    pop rax
    ret