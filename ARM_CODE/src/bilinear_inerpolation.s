.global main

.equ    IMAGE_SIZE,     10000


.section .data
    interp_matrix   .word   16
.section .bss

    src_image:      .word    0
    improved_image: .space   IMAGE_SIZE
.section .text

_start: 
    ldr r0, image

sides:
    


interpolation_for_sides:
    @r1=x1 posicion de esquina superior izquierda
    @r2=x2 posición de esquina superior derecha
    @r3=v1 valor de esquina superior izquierda
    @r4=v2 valor de esquina superior derecha
    @r5=x  posicion del valor a calcular
    push{r2-r9, lr}
    sub r6, r2, r5
    sub r7, r2, r1
    udiv r6, r6, r7
    mul r6, r6, r3

    sub r8, r5, r1
    sub r9, r2, r1
    udiv r9, r9, r8
    mul r9, r9, r4

    add r1, r9, r6

    pop {r2-r9, lr}
    bx lr




    

    