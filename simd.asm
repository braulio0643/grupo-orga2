global fir_filter_simd
extern fir_filter
%define COEFS_OFFSET 0
%define LENGTH_OFFSET 8
%define BUFFER_OFFSET 12
%define FIR_T_SIZE 16
; size_t fir_filter_simd(FIR_t*filtro[rdi], int16_t *in[rsi], unsigned length[edx], int16_t *out[rcx]);
fir_filter_simd:

;epilogo
push rbp
mov rbp, rsp
push r12
push r13
mov r11, rcx

xor rcx, rcx
mov ecx, edx
shl rcx,1
shr rcx,6

;filtro->buffer[filtro->length - 1]..
mov r8, rdi
add r8, BUFFER_OFFSET
add r8, [rdi + LENGTH_OFFSET]
dec r8
memcpytrucho:
    mov rax, [rsi]
    mov r8, rax
    add rsi, 8
    add r8,8
loop memcpytrucho
xor r10,r10
.loopexterno:
    ;rdi: estructura. rdx: longitud del audio. r8: puntero a coeficiente. r9: (in_p) posicion a leer del buffer
    ;
    pxor xmm0,xmm0 ;acumulador
    mov r8, [rdi + COEFS_OFFSET] ;coef
    mov r9, [rdi+LENGTH_OFFSET]
    mov rcx, r9
    dec r9
    add r9, r10
    add r9, rdi
    add r9,BUFFER_OFFSET ; posicion a leer del buffer
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
    movq r12, xmm0  
    cmp r12, 0x3fffffff
    jle .no_saturar_mayor
    mov r12 ,0x3fffffff
    .no_saturar_mayor:
    cmp qword r12, -0x40000000
    jge .fin
    mov r12,-0x40000000
    .fin:
    shr r12, 15
    mov rax, r11
    add rax, r10
    mov  [r11], r12
    inc r10
    cmp r10,rdx
    jl .loopexterno

mov r8, rdi
add r8, BUFFER_OFFSET
mov r9,r8
add r9, rdx
dec r9
memmovetrucho:
    mov rax, [r9]
    mov r8, rax
    add r9, 8
    add r8,8
    cmp r8, rdx
    jl memmovetrucho
mov rax, rdx
;prologo


pop r13
pop r12
pop rbp

ret
    
    
