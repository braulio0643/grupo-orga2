; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"

global start


; COMPLETAR - Agreguen declaraciones extern según vayan necesitando
extern GDT_DESC; // Descriptor de la gdt | gdtr??
extern screen_draw_layout
extern IDT_DESC
extern idt_init
extern pic_reset
extern pic_enable

extern mmu_init_kernel_dir
extern copy_page
extern mmu_init_task_dir

extern tss_init
extern tasks_screen_draw
%define TASK_INITIAL_SEL  11 << 3
%define TASK_IDLE_SEL     12 << 3

extern sched_init
extern tasks_init

; COMPLETAR - Definan correctamente estas constantes cuando las necesiten
%define CS_RING_0_SEL 0x0001 << 3
%define DS_RING_0_SEL 0x0003 << 3


BITS 16
;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

task_pm_msg db     'Esto se esta imprimiendo desde una tarea'
task_pm_len equ    $ - task_pm_msg
;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; COMPLETAR - Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO REAL
    ; (revisar las funciones definidas en print.mac y los mensajes se encuentran en la
    ; sección de datos)
    print_text_rm start_rm_msg, start_rm_len, 0x0000ffff, 0, 0  

    ; COMPLETAR - Habilitar A20
    ; (revisar las funciones definidas en a20.asm)
    call A20_enable

    ; COMPLETAR - Cargar la GDT
    lgdt [GDT_DESC] 

    ; COMPLETAR - Setear el bit PE del registro CR0
    mov eax, cr0
    or dword eax, 0x00000001
    mov cr0, eax

    ; COMPLETAR - Saltar a modo protegido (far jump)
    ; (recuerden que un far jmp se especifica como jmp CS_selector:address)
    ; Pueden usar la constante CS_RING_0_SEL definida en este archivo
    jmp CS_RING_0_SEL:modo_protegido


BITS 32
modo_protegido:
    ; COMPLETAR - A partir de aca, todo el codigo se va a ejectutar en modo protegido
    ; Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    ; Pueden usar la constante DS_RING_0_SEL definida en este archivo
    mov ax, DS_RING_0_SEL
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov fs, ax
    mov ss, ax
    
    ; COMPLETAR - Establecer el tope y la base de la pila
    mov esp, 0x25000
    mov ebp, 0x25000

    ; COMPLETAR - Imprimir mensaje de bienvenida - MODO PROTEGIDO
    print_text_pm start_pm_msg, start_pm_len, 0x0000ffff, 0, 0  
    ; COMPLETAR - Inicializar pantalla
        
    call screen_draw_layout 

    ; Inicializar idt
    call idt_init
    lidt [IDT_DESC]

    call pic_reset
    call pic_enable


    call mmu_init_kernel_dir 

    and eax, 0xFFFFF000
    add eax, 0x10
    mov cr3, eax
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    call tss_init

    mov ax, TASK_INITIAL_SEL
    ltr ax

    call sched_init
    call tasks_init
    sti

    jmp TASK_IDLE_SEL:0


    xchg bx, bx

    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
