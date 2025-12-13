%define STR_DATA 0
%define STR_LEN 8
%define STR_SIZE 16

section .data
    hello db "Hello hammPa!", 10
    hello_len equ $-hello

    world db "World", 10
    world_len equ $-world

    newline db 10
    newline_len equ 1

section .bss
    string1 resb STR_SIZE
    string2 resb STR_SIZE
    concat_result resb STR_SIZE


section .text
    global _start

_start:
    ; --------------------------------------------- string1 = "Hello, hammPa!\n" ---------------------------------------------
    lea rax, [hello]                                ; simpan alamat variabel hello ke rax, char* rax = &hello
    mov [string1 + STR_DATA], rax                   ; pindahkan alamat didalam rax sebagai value di alamat struct string1
    mov qword [string1 + STR_LEN], hello_len        ; pindahkan panjang string ke dalam struct string1

    ; --------------------------------------------- PRINT STRING1 ---------------------------------------------
    lea rdi, [string1]                              ; ambil alamat variabel struct string1
    call print_struct_string





    ; --------------------------------------------- string2 = "World\n" ---------------------------------------------
    lea rax, [world]
    mov [string2 + STR_DATA], rax
    mov qword [string2 + STR_LEN], world_len

    ; --------------------------------------------- CONCAT STRING ---------------------------------------------
    lea rdi, [string1]
    lea rsi, [string2]
    lea rdx, [concat_result]
    call concat_string

    ; --------------------------------------------- PRINT HASIL CONCAT ---------------------------------------------
    lea rdi, [concat_result]
    call print_struct_string

    mov rax, 60         ; exit
    mov rdi, 0
    syscall


print_struct_string:
    mov rdx, [rdi + STR_LEN]                        ; ambil nilai panajng string yang tersimpan sebagai value pada alamat dalam rdi
    mov rsi, [rdi + STR_DATA]                       ; ambil alamat string yang tersimpan sebagai value pada alamat dalam rdi
    mov rdi, 1
    mov rax, 1
    syscall
    ret



concat_string:
    mov r8, rdi                                     ; r8 = a
    mov r9, rsi                                     ; r9 = b
    mov r10, rdx                                    ; r10 = buffer

    ; total panjang
    mov r11, [r8 + STR_LEN]                         ; ambil panjang (string a - 1 (hilangkan newline) ) ke r11
    dec r11
    add r11, [r9 + STR_LEN]                         ; jumlahkan dengan panajng string b ke r11

    ; alloc(total panjang)
    mov rdi, r11
    call alloc_mmap

    ; rax = buffer
    mov [r10 + STR_DATA], rax                       ; atribut data berisi alamat alokasi
    mov [r10 + STR_LEN], r11                        ; atribut len berisi total panjang

    ; copy a
    mov rdi, rax                                    ; pindahkan alamat yang baru dialokasi ke rdi
    mov rsi, [r8 + STR_DATA]                        ; pindahkan value berisi alamat string a ke rsi
    mov rcx, [r8 + STR_LEN]                         ; pindahkan panjang - 1 (karna hapus newline)
    dec rcx
    rep movsb


    ; rep movsb
    ; copy 1 byte dari rsi ke rdi, lalu increment keduanya
    ; ulangi sebanyak nilai di rcx

    ; copy b
    mov rsi, [r9 + STR_DATA]                        ; pindahkan value berisi alamat string b ke rsi
    mov rcx, [r9 + STR_LEN]
    rep movsb

    ret


alloc_mmap:
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11

    ; arg: rdi = size
    mov rsi, rdi        ; rsi = size
    mov rax, 9          ; sys_mmap
    xor rdi, rdi        ; addr = NULL
    mov rdx, 3          ; PROT_READ | PROT_WRITE
    mov r10, 34         ; MAP_PRIVATE | MAP_ANONYMOUS
    mov r8, -1          ; fd = -1
    xor r9, r9          ; offset = 0
    syscall

    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    ret
