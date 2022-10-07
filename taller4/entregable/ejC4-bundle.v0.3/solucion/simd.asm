global fir_filter_simd
extern fir_filter
extern memcpy
extern memmove
%define COEFS_OFFSET 0
%define LENGTH_OFFSET 8
%define BUFFER_OFFSET 12

section .data
;0000;0001;0002; 0003;
;0004;0005;0006; 0007;
;0E0F;0C0D;0A0B;0809;
;0607;0405;0203;0001; 
;mask1: DQ 0X0F0E0D0C0B0A0908    
;mask2: DQ 0x0706050403020100
mask1: DQ 0x0100030205040706
mask2: DQ 0x09080B0A0D0C0F0E

section .text
; size_t fir_filter_simd(FIR_t*filtro[rdi], int16_t *in[rsi], unsigned length[edx], int16_t *out[rcx]);
fir_filter_simd:
;epilogo
push rbp;alienada
mov rbp, rsp

push rdi ;desalineada
push rsi ;alineada
push rdx ;desalineada
push rcx ;alineada

;memcpy(&filtro->buffer[filtro->length - 1], in, length * sizeof(int16_t));
mov r8, rdi                     ; *filtro
add r8, BUFFER_OFFSET           ; *filtro->buffer
mov r9, rdi                     ; *filtro 
add r9, LENGTH_OFFSET           ; *filtro->length
mov r9, [r9]                    ; filtro->length
dec r9                          ; filtro->length - 1
sal r9, 1                       ; 2*(filtro->length - 1) // offset length - 1
add r8, r9                      ; *filtro->buffer[length - 1]
mov rdi, r8                     ; *filtro->buffer[length - 1]
sal edx, 1                      ; length * sizeof(int16_t)

call memcpy WRT ..plt
pop rcx
pop rdx 
pop rsi
pop rdi

xor r10,r10

.loopexterno:
    ;rdi: estructura. rdx: longitud del audio. r8: puntero a coeficiente. r9: (in_p) posicion a leer del buffer
    pxor xmm0,xmm0                 ; acumulador
    mov r8, [rdi + COEFS_OFFSET]   ; coef
    mov r9, [rdi+LENGTH_OFFSET]    ; long
    mov r11, r9 ; long
    add r9, r10 ; length + n
    sub r9, 8 ; length + n - 8 para cargar en el buffer 
    sal r9, 1 ; offset del item [length + n - 8]
    add r9, rdi
    add r9, BUFFER_OFFSET ; filtro->buffer[filtro->length - 1 + n]
    ;en C
    ;1. in_p = 0x7fffffe76bda. despues de terminar= 0x7fffffe76b2a
    ;2. in_p = 0x7fffffe76bdc
    
    ;en ASM
    ;1. in_p = 0x7fffffe76bcc
    ;2. in_p = 0x7fffffe76bd0

    ;r -s -f highpass -o outputs/asaddad_simd.wav wavs/muestra.wav
        .innerloop:
            ;acc += (int32_t)(*coeff_p++) * (int32_t)(*(in_p--))
            movdqu xmm1, [r9] ; cargo 16 bytes buffer en xmm1
            movdqu xmm2, [mask1]
            movdqu xmm3, [mask2]
            movlhps xmm3, xmm2
            ;tengo la mascara en xmm3
            pshufb xmm1, xmm3
          
            pmaddwd xmm1, [r8] ; multiplicamos los coefs con el buffer
            paddd xmm0,xmm1
            sub r11, 8
            sub r9, 16
            add r8, 16
            cmp r11, 0
        jg .innerloop
    phaddd xmm0, xmm0
    phaddd xmm0, xmm0
    movd esi, xmm0 
    cmp esi, 0x3fffffff
    jle .no_saturar_mayor
    mov esi ,0x3fffffff
    .no_saturar_mayor:
    cmp esi, -0x40000000
    jge .fin
    mov esi, -0x40000000
    .fin:
    sar esi, 15
    mov word [rcx], si
    inc rcx
    inc rcx
    inc r10
    cmp r10, rdx
    jl .loopexterno
    



;; memmove(&filtro->buffer[0], &filtro->buffer[length], (filtro->length - 1) * sizeof(int16_t));
mov r8, rdi                     ; *filtro
add r8, BUFFER_OFFSET           ; *filtro->buffer
xor r9,r9
mov r9, rdx                    ; length
sal r9, 1                      ; length offset
add r9, r8                      ; *filtro->buffer[length]
mov r10, [rdi + LENGTH_OFFSET]  ; filtro.length
dec r10                         ; filtro.length - 1
sal r10,1                       ; (filtro.length - 1) * sizeof(int16_t)
push rdx; desalineada

mov rdi, r8                     ; *filtro->buffer
mov rsi, r9                     ; *filtro->buffer[length]
mov rdx, r10                    ; (filtro.length - 1) * sizeof(int16_t)

call memmove WRT ..plt
pop rdx

mov rax, rdx
;prologo

pop rbp
ret
    
    
