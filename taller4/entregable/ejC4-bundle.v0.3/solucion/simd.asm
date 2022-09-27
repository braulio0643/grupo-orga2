global fir_filter_simd
extern fir_filter
extern memcpy
extern memmove
%define COEFS_OFFSET 0
%define LENGTH_OFFSET 4
%define BUFFER_OFFSET 8
%define FIR_T_SIZE 12
; size_t fir_filter_simd(FIR_t*filtro[rdi], int16_t *in[rsi], unsigned length[edx], int16_t *out[rcx]);
fir_filter_simd:

;epilogo
push rbp;alienada
mov rbp, rsp

push rdi ;desalineada
push rsi ;alineada
push rdx ;desalineada
push rcx ;alineada

mov r8, rdi
add r8, BUFFER_OFFSET
add r8, [rdi + LENGTH_OFFSET]
dec r8; filtro->buffer[filtro->length - 1]
mov rdi, r8

sal rdx, 1
call memcpy WRT ..plt

pop rcx
pop rdx 
pop rsi
pop rdi

xor r10,r10

.loopexterno:
    ;rdi: estructura. rdx: longitud del audio. r8: puntero a coeficiente. r9: (in_p) posicion a leer del buffer
    pxor xmm0,xmm0 ;acumulador
    mov r8, [rdi + COEFS_OFFSET] ;coef
    mov r9, [rdi+LENGTH_OFFSET]; long
    mov rcx, r9 ; long
    add r9, r10 ; length + n
    dec r9 ; length + n - 1 
    add r9, rdi
    add r9,BUFFER_OFFSET ; filtro->buffer[filtro->length - 1 + n]
        .innerloop:
            ;acc += (int32_t)(*coeff_p++) * (int32_t)(*(in_p--))
            movups xmm1, [r9] ; cargo 16 bytes buffer en xmm1
            pmaddwd xmm1, [r8] ; multiplicamos los coefs con el buffer
            paddd xmm0,xmm1
            sub rcx, 16
            sub r9, 16
            add r8, 16
            cmp rcx, 0
        jg .innerloop
    phaddd xmm0, xmm0
    phaddd xmm0, xmm0
    movq rsi, xmm0 
    cmp rsi, 0x3fffffff
    jle .no_saturar_mayor
    mov rsi ,0x3fffffff
    .no_saturar_mayor:
    cmp rsi, -0x40000000
    jge .fin
    mov rsi, -0x40000000
    .fin:
    sar rsi, 15
    mov rax, r11
    add rax, r10
    mov  [r11], rsi
    inc r10
    cmp r10, rdx
    jl .loopexterno
    



mov r8, rdi
add r8, BUFFER_OFFSET ; buffer
xor r9,r9
add r9d, edx ; buffer[length]
mov r9, r8
mov r10, rdi
add r10, BUFFER_OFFSET
add r10, [rdi + LENGTH_OFFSET]
dec r10; filtro->buffer[filtro->length - 1]
sal r10, 1
push rdx; desalineada
mov rdi, r8
mov rcx, r9
mov rdx, r10

call memmove WRT ..plt


pop rdx

mov rax, rdx
;prologo

pop rbp
ret
    
    
