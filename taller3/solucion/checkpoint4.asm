extern malloc
extern free
extern fprintf

section .data
nullStr db 'NULL'
section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
push rbp
mov rbp, rsp

.loopstart:
mov al, [rdi]
mov ah, [rsi]
cmp al, ah
JE .incr
JG .mayor
JL .menor

.incr:
cmp rdi, rsp  ;para resetear el flag Z
cmp byte [rdi], 0 
JE .iguales
inc rdi
inc rsi
jmp .loopstart

.menor:
mov rax, 1
jmp fin

.mayor:
mov rax, -1
jmp fin

.iguales:
mov rax, 0    ;para el caso en el que son los 2 caracteres iguales, pero además son el último caracter

fin:
pop rbp
ret

; char* strClone(char* a)
strClone:
;epilogo
push rbp ;alineada
mov rbp,rsp
push rbp ; desalineada
push rbx ; alineada

;desarrollo
mov rbp,rdi ; origen
xor rbx,rbx ; longitud
call strLen ; conseguimos la longitud del string
inc eax ; sumamos 1 a la longitud del string para el caracter null
mov ebx,eax; nos guardamos la longitud
mov rdi,rbx ; guardamos el la long en edx para llamar el malloc
call malloc WRT ..plt  ; rax tiene la direccion de memoria para el nuevo array
mov r9, rax ; direccion a escribir
mov rcx, rbx
.copiarLoop:
  mov bl, [rbp]
  mov [r9], bl
  inc rbp
  inc r9
loop .copiarLoop
pop rbx
pop rcx
pop rbp
ret

; void strDelete(char* a)
strDelete:
push rbp
mov rbp, rsp
call free WRT ..plt
pop rbp
ret

; void strPrint(char* a, FILE* pFile)
strPrint:
push rbp
mov rbp, rsp
cmp byte [rdi], 0
jnz .llamar_fprintf
mov rdi, nullStr
.llamar_fprintf:
mov rax, rdi
mov rdi, rsi
mov rsi, rax
call fprintf WRT ..plt

pop rbp
ret

; uint32_t strLen(char* a)
strLen:
mov eax, 0
checkEnd: 
cmp byte [rdi], 0
je endLen
inc eax
inc rdi
jmp checkEnd
endLen:
ret


