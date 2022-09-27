
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global complex_sum_z
global packed_complex_sum_z
global product_9_f

;########### DEFINICION DE FUNCIONES
;extern uint32_t complex_sum_z(complex_item *arr, uint32_t arr_length);
;registros: arr[edi], arr_length[esi]
complex_sum_z:
	;prologo
    push rbp
    mov rbp, rsp
    mov rcx, rsi 
    mov rax, 0x0
.cycle:			; etiqueta a donde retorna el ciclo que itera sobre arr
    add eax, dword [rdi + 8*3]
	add rdi, 8*4
	
	loop .cycle		; decrementa ecx y si es distinto de 0 salta a .cycle

	
	;epilogo
    pop rbp
	ret
	
;extern uint32_t packed_complex_sum_z(packed_complex_item *arr, uint32_t arr_length);
;registros: arr[?], arr_length[?]
packed_complex_sum_z:
	;prologo
    push rbp
    mov rbp, rsp
    mov rcx, rsi 
    mov rax, 0x0
.cycle:			; etiqueta a donde retorna el ciclo que itera sobre arr
    add eax , dword [rdi + 20]
	add rdi, 24
	
	loop .cycle		; decrementa ecx y si es distinto de 0 salta a .cycle

	
	;epilogo
    pop rbp
	ret
	
	ret


;extern void product_9_f(uint32_t * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rcx], f2[xmm1], x3[rdx], f3[xmm2], x4[r8], f4[xmm3]
;	, x5[r9], f5[xmm4], x6[rbp + 0x10] (ni idea si esta bien), f6[xmm5], x7[rbp + 0x18], f7[xmm6], x8[rbp + 0x20], f8[xmm7],
;	, x9[rbp + 0x28], f9[rbp + 0x30]
product_9_f:

	;prologo 
	push rbp
	mov rbp, rsp
	
	;convertimos los flotantes de cada registro xmm en doubles
	;habria que usar CVTSS2SD (de single precision floating point a double precision floating point)
  cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm2, xmm2
	cvtss2sd xmm3, xmm3
	cvtss2sd xmm4, xmm4
	cvtss2sd xmm5, xmm5
	cvtss2sd xmm6, xmm6
	cvtss2sd xmm7, xmm7

    ;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	;dejo x9 para el final ya que quedó en el stack y me quedé sin registros de flotantes
    ;uso MULSD (multiply scalar double precision floating point value)
  mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7

    
	;ahora convierto x9 y lo multiplico (dudosisimo)
	cvtss2sd xmm7, dword [rbp + 0x30]
	mulsd xmm0, xmm7

	; convertimos los enteros en doubles y los multiplicamos por xmm0. 
	; habria que usar CVTSI2SD (dw integer to scalar double precision floating point value)

	cvtsi2sd xmm1, esi
	cvtsi2sd xmm2, ecx
	cvtsi2sd xmm3, edx
	cvtsi2sd xmm4, r8d
	cvtsi2sd xmm5, r9d
	cvtsi2sd xmm6, dword [rbp + 0x10]
	cvtsi2sd xmm7, dword [rbp + 0x18]

	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7
	
	cvtsi2sd xmm1, dword [rbp + 0x20]
	cvtsi2sd xmm2, dword [rbp + 0x28]
	
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2

	movq [rdi], xmm0

    

	; COMPLETAR 

	; epilogo 
	pop rbp
	ret

