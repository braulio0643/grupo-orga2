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
;cmps [rdi], 0
;JE menor
;cmps [rsi], 0
;JE mayor

cmpsb [rdi], [rsi]
JE incr
JG mayor
JL menor

incr:
inc rdi
inc rsi
jmp loopstart

menor:
mov ecx, 1
jmp fin

mayor:
mov ecx, -1
jmp fin

fin:
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


