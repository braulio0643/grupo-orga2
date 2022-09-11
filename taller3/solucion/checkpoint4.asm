extern malloc
extern free
extern fprintf

section .data

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

loopstart:
mov al, [rdi]
mov ah, [rsi]
cmp al, ah
JE incr
JG mayor
JL menor

incr:
cmp rdi, rsp  ;para resetear el flag Z
cmp byte [rdi], 0 
JE iguales
inc rdi
inc rsi
jmp loopstart

menor:
mov rax, 1
jmp fin

mayor:
mov rax, -1
jmp fin

iguales:
mov rax, 0    ;para el caso en el que son los 2 caracteres iguales, pero además son el último caracter

fin:
pop rbp
ret

; char* strClone(char* a)
strClone:
ret

; void strDelete(char* a)
strDelete:
ret

; void strPrint(char* a, FILE* pFile)
strPrint:
ret

; uint32_t strLen(char* a)
strLen:
ret


