.global main

.equ    IMAGE_SIZE,     10000
.equ    IMP_IMAGE,     40000


.section .data
    interp_matrix   .word   16
    esquina_si      .word   0
    esquina_sd      .word   0
    esquina_ii      .word   0
    esquina_id      .word   0
.section .bss

    src_image:      .word    IMAGE_SIZE
    improved_image: .space   
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
    add r2, #2
    b loop_image
    continue_loop:

    @offset adding
    mov r3, #0 
    mul r4, r2, #100
    add r3, r1, r4 @add chunk_counter*vertical_offset

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

    bl intr_matrx_calculation


    add r1, r1, #2
    b curr_2x2_row
intr_matrx_calculation:
    sides:
        push{r0-r5, lr}
        ldr r0, =interp_matrix

        @position 2
        mov r1, #1
        mov r2, #4
        ldr r3, esquina_si
        ldr r4, esquina_sd
        mov r5, #2

        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]
        
        @position 3
        mov r1, #1
        mov r2, #4
        ldr r3, esquina_si
        ldr r4, esquina_sd
        mov r5, #3

        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]

        @position 5
        mov r1, #1
        mov r2, #13
        ldr r3, esquina_si
        ldr r4, esquina_ii
        mov r5, #5

        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]

        @position 9
        mov r1, #1
        mov r2, #13
        ldr r3, esquina_si
        ldr r4, esquina_ii
        mov r5, #9

        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]

        @position 14
        mov r1, #13
        mov r2, #16
        ldr r3, esquina_ii
        ldr r4, esquina_id
        mov r5, #14

        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]

        @position 15
        mov r1, #13
        mov r2, #16
        ldr r3, esquina_ii
        ldr r4, esquina_id
        mov r5, #15

        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]

        @position 8
        mov r1, #4
        mov r2, #16
        ldr r3, esquina_sd
        ldr r4, esquina_id
        mov r5, #8
        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]

        @position 12
        mov r1, #4
        mov r2, #16
        ldr r3, esquina_sd
        ldr r4, esquina_id
        mov r5, #12
        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]
    interior:

        @position 6
        mov r1, #5
        mov r2, #8
        ldr r3, [r0, #4]
        ldr r4, [r0, #7]
        mov r5, #6
        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]

        @position 7
        mov r1, #5
        mov r2, #8
        ldr r3, [r0, #4]
        ldr r4, [r0, #7]
        mov r5, #7
        bl interpolation_for_nm

        add r5, r5, #-1
        str r1, [r0, r5]

        @position 10
        mov r1, #9
        mov r2, #12
        ldr r3, [r0, #8]
        ldr r4, [r0, #11]
        mov r5, #10
        
        add r5, r5, #-1
        str r1, [r0, r5]

        @position 11
        mov r1, #9
        mov r2, #12
        ldr r3, [r0, #8]
        ldr r4, [r0, #11]
        mov r5, #11
        
        add r5, r5, #-1
        str r1, [r0, r5]
    esquinas:
        @guarda posicion 1
        ldr r1, =esquina_si
        ldr r1, [r1]
        str r1, [r0]

        @guarda posicion 4
        ldr r1, =esquina_sd
        ldr r1, [r1]
        str r1, [r0, #3]

        @guarda posicion 13
        ldr r1, =esquina_ii
        ldr r1, [r1]
        str r1, [r0, #12]

        @guarda posicion 16
        ldr r1, =esquina_id
        ldr r1, [r1]
        str r1, [r0, #15]

        pop{r0-r5, lr}
        bx lr
matrix_2_image:
    ldr r3, = IMP_IMAGE



interpolation_for_nm:
    @r1=x1 posicion de esquina inicial
    @r2=x2 posición de esquina final
    @r3=v1 valor de esquina inicial
    @r4=v2 valor de esquina final
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
    


    

    