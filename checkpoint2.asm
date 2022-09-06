extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_simplified
global alternate_sum_8
global product_2_f
global alternate_sum_4_using_c

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rsx]
alternate_sum_4:
	;prologo
	; COMPLETAR 
    push rbp 
    mov rbp , rsp
	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8
  ;devuelve el resultado de la operación x1 - x2 + x3 - x4
    SUB rdi, rsi
    ADD rdi, rdx
    SUB rdi, rcx
    MOV rax, rdi
	;epilogo
	; COMPLETAR 
    pop rbp
    ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_using_c: 

	;prologo
    push rbp ; alineado a 16
    mov rbp,rsp
    
    CALL restar_c
    MOV  rdi, rax
    MOV rsi, rdx
    CALL sumar_c
    MOV rdi, rax
    MOV rsi, rcx
    CALL restar_c
    
	;epilogo
	pop rbp
  ret 



; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]

alternate_sum_4_simplified:
	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);	
; registros y pila: x1[rdi], x2[rsi], x3[rdx], x4[rcx], x5[r8], x6[r9], x7[rbp+0x10], x8[rbp+0x18]
alternate_sum_8:
	;prologo
    push rbp 
    mov rbp , rsp
    

	; COMPLETAR
    SUB rdi, rsi
    ADD rdi, rdx
    SUB rdi, rcx
    ADD rdi, r8
    SUB rdi, r9
    ADD rdi, [rbp+0x10]
    SUB rdi, [rbp+0x18]
    MOV rax, rdi 



	;epilogo
  pop rbp
	ret
	

; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[rdi], x1[rsi], f1[xmm0]
product_2_f:
  push rbp
  mov rbp, rsp

  cvtsi2ss xmm1, esi
  mulss xmm0,xmm1
  cvtss2si esi, xmm0
  mov   dword [rdi],esi
  
  pop rbp
	ret

