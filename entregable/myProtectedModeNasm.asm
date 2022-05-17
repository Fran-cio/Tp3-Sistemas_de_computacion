;Inicio de sector de booteo
[org 0x7c00]
    ;Limpio la consola
    mov ah, 0
    mov al, 0x03
    int 0x10

    ;Imprimo un mensaje en modo real haciendo uso de la interrupcion 0x10
    mov si, msg_modo_real
    mov ah, 0x0e
loop:
    lodsb
    or al, al ;Es necesario hacer el or sino se imprime cualquier cosa
    jz goto_protected
    int 0x10
    jmp loop
goto_protected:
    call cambio_a_MP ;Nunca vuelve de la subrutina
   
;GDT
gdt_start:
    gdt_null:          ; El descriptor nulo
    dd 0x0             
    dd 0x0
        
gdt_code:                  ; El  segmento descriptor de codigo
                           ; base=0x0, limit=0xfffff ,
                           ; 1st flags: (present)1 (privilege)00 
                           ;(descriptor type)1 -> 1001b
                           ; tipo flags: (code)1 (conforming)0 
                           ;(readable)1 (accessed)0 -> 1010b
                           ; 2nd flags: (granularity)1 (32 -bit )1
                           ; (64 -bit seg)0 (AVL)0 -> 1100b
    dw 0xFFFF              ; Limite (bits 0 -15)
    dw 0x0                 ; Base (bits 0 -15)
    db 0x0                 ; Base (bits 16 -23)
    db 10011010b           ; 1001(P DPL S) 1010(type codigo no 
                           ;accedido)
    db 11001111b           ; 1100 ( G D/B 0 AVL)  ,1111  Limite
                           ; (bits 16 -19)
    db 0x0                 ; Base (bits 24 -31)

gdt_data:                  ; El  segmento descriptor de datos
                           ; Igual que el segmento de código 
                           ;ecepto por los flags.
                           ; type flags: (code)0 (expand down)0 
                           ;(writable)1 (accessed)0 -> 0010b
    dw 0xFFFF              ; Limite (bits 0 -15)
    dw 0x0                 ; Base (bits 0 -15)
    db 0x0                 ; Base (bits 16 -23)
    db 10010010b           ;  1001(P DPL S) 0010(type codigo no 
                           ;accedido)
    db 11001111b           ; 1100 ( G D/B 0 AVL)  ,1111  Limite 
                           ;(bits 16 -19)
    db 0x0                 ; Base (bits 24 -31)
gdt_end:                   ; El motivo para colocar un rotulo al 
                           ;final de la tabla GDT es que el     
                           ; compilador pueda calcular la longitud
                           ; de la tabla  gdt_end - gdt_start - 1
                             
;GDT descriptor
gdt_descriptor:
        dw gdt_end - gdt_start - 1 ; El tamaño de la tabla gdt es uno menos del calculado
        dd gdt_start               ; Dirección de comienzo de la GDT

; A continuacion se definen dos constantes utiles para el offset  que  los descriptores GDT
; deben contener cuando se entra en modo protegido. Por ejemplo ,
; cuando se setea DS = 0x10 en PM, El  CPU sabe que significa usar el segmento 
; descripto en el  offset 0x10 (i.e. 16 bytes) de la tabla GDT, la cual en nuestro caso 
; el segmento de datos (DATA segment)  (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

[bits 16]
cambio_a_MP:
    cli                     ;Apagamos las interrupciones hasta que hayamos  
                            ; conmutado a modo protegido
    lgdt [gdt_descriptor]   ; Cargamos la dirección y tamaño de la tabla GDT
    mov eax, cr0            ; Ponemos el bit 0 en uno del reg cr0 para pasar a modo protegido
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG : iniciar_MP  ; Hacemos un salto largo al nuevo segmento  de 32 bits
                                            ; El CPU fuerza a limpiar el cache

[bits 32]
; Inicializamos los registros de segmento y el stack.
iniciar_MP:
    mov ax, DATA_SEG 
    mov ds, ax 
    mov ss, ax 
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x7000        ; Inicializamos el stack; En que posicion?
    mov esp, ebp
 
    ;A partir de este momento estamos listos para ejecutar cualquier cosa en modo protegido
    mov ebx, msg_modo_protegido
    call print_string_pm ; Usamos  nuestra rutina para imprimir en MP.

    ;mov ebx, data_only_read
    ;call print_string_pm ; Usamos  nuestra rutina para imprimir en PM.
    jmp $ ; Hang.

VIDEO_MEMORY equ 0xb8000 + 160
WHITE_ON_BLACK equ 0x0f
; Imprime una cadena de caracteres terminadas en null apuntada por  EBX
print_string_pm:
           pusha
           mov edx, VIDEO_MEMORY    ;Se inicializa EDX a la segunda
                                    ;linea de la memoria de video.
print_string_pm_loop:
           mov al, [ebx]            ;El caracter apuntado por  EBX 
                                    ;se mueve a  AL
           mov ah, WHITE_ON_BLACK   ;Carga AH con el atributo de
                                    ;video
           cmp al, 0                ;si (al = 0) fin de la cadena
           je print_string_pm_done  ;si no salta a done
           mov [edx] , ax           ;Almacena el caracter en la
                                    ;memoria de video
           add ebx, 1               ;Incremento EBX al proximo
                                    ;caracter.
           add edx, 2               ;Apunto al proximo caracter
                                    ;en la memoria de video.
           jmp print_string_pm_loop ;loop a proximo caracter.
print_string_pm_done:
           popa
           ret  

; Variables Globales
msg_modo_real db "Modo Real - 16 bits" , 0
msg_modo_protegido db "Modo protegido - 32 bits", 0
; Rellenamos el Bootsector 
times 510 -( $ - $$ ) db 0
dw 0xaa55