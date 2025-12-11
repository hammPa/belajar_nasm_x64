section .data
    msgStr db "Masukkan string yang mau di looping: ", 0
    msgStrLen equ $ - msgStr

    msgNum db "Masukkan berapa kali diulang (1 - 9): ", 0
    msgNumLen equ $ - msgNum

    newline db 10, 0

section .bss
    teks1 resb 128                            ; alamat yang akan menyimpan teks
    teks1Len resb 8
    teks2 resb 8

section .text
    global _start

_start:
    ; --------------------------------------------- TEKS 1 ---------------------------------------------
    ; pesan input teks
    mov rdi, msgStr
    mov rsi, msgStrLen
    call print_str

    ; input teks 1
    mov rdi, teks1
    call scan_str
    
    ; panjang dari teks 1 yang akan di loop dihitung dari rax
    mov qword [teks1Len], rax



    ; --------------------------------------------- TEKS 2 ---------------------------------------------
    ; pesan input angka
    mov rdi, msgNum
    mov rsi, msgNumLen
    call print_str

    ; input teks 2
    mov rdi, teks2
    call scan_str


    ; convert ke angka
    mov al, byte [teks2]
    sub al, '0'
    mov byte [teks2], al 


    ; --------------------------------------------- LOOP ---------------------------------------------
    xor r8, r8                              ; counter = 0
    mov r9, [teks2]                         ; ambil nilai yang disimpan di memory teks2, batas = x

.loop_str:
    cmp r8, r9
    jge .exit_loop_str

    ; print
    mov rdi, teks1                          ; ambil alamat
    mov rsi, [teks1Len]
    call print_str

    mov rdi, newline
    mov rsi, 1
    call print_str

    inc r8
    jmp .loop_str

.exit_loop_str:


    ; --------------------------------------------- RETURN 0 ---------------------------------------------
    mov rax, 60         ; exit
    mov rdi, 0
    syscall



print_str:
    mov rdx, rsi                            ; mov length
    mov rsi, rdi                            ; mov str addres
    mov rax, 1
    mov rdi, 1
    syscall
    ret


scan_str:
    ; btw disini kalau mau pakai var lokal pokoknnya disini tidak boleh rcx, blm tau alasannya, sejauh ini baru nyoba r12
    ; --------------------------------------------- INPUT ---------------------------------------------
    mov rsi, rdi                            ; buffer = alamat string
    mov rax, 0
    mov rdi, 0
    mov rdx, 128
    syscall


    mov rcx, rax
    dec rcx                                 ; rcx = index terakhir
    cmp byte [rsi + rcx], 10             ; apakah newline ?
    jne .skip_newline                       ; kalau bukan, skip

    mov byte [rsi + rcx], 0              ; ganti \n menjadi \0
    mov rax, rcx

.skip_newline:

    ret