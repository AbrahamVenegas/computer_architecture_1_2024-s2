.global main

.equ    IMAGE_SIZE,     10000


.section .data
    interp_matrix   .word   16
    esquina_si      .word   0
    esquina_sd      .word   0
    esquina_ii      .word   0
    esquina_id      .word   0
.section .bss

    src_image:      .word    0
    improved_image: .space   IMAGE_SIZE
.section .text

_start: 
    ldr r0, image
    mov r1, #0      @chunk counter
    mov r2, #0      @y offset
loop_image:
    cmp r2, #100
    bge exit
    curr_2x2_row:
    cmp r1, #100
    ble continue_loop
    mov r1, #0
    add r2, #1
    b loop_image
    continue_loop:

    @offset adding
    mov r3, #0 
    add r3, r3, r1 @add chunk counter
    add r3, r3, r2 @add vertical offset

    @superior izquierda
    ldr r4, [r0, r3]
    ldr r5, =esquina_si
    str r4, [r5]

    @superior derecha
    add r3, r3, #1
    ldr r4, [r0, r3]
    str r5, =esquina_sd
    str r4, [r5]

    @inferior izquierda
    add r3, r3, #99
    ldr r4, [r0, r3]
    str r5, =esquina_ii
    str r4, [r5]

    @inferior derecha
    add r3, r3, #1
    ldr r4, [r0, r3]
    str r5, =esquina_id
    str r4, [r5]

    bl sides

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

exit:
    


    

    