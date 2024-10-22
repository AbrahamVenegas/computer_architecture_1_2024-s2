.global main

.equ    IMAGE_SIZE,     10000
.equ    IMP_IMAGE,     40000


.section .data
    interp_matrix:   .byte   16 //0x30D40
    esquina_si:      .byte   0 //0x30E40
    esquina_sd:      .byte   0 //0x30E44
    esquina_ii:      .byte   0 //0x30E48
    esquina_id:      .byte   0 //0x30E4C
    src_image_addr:  .word   0 //0x30E50


    src_image:      .space   IMAGE_SIZE //[0x30E50]
    improved_image: .space   IMP_IMAGE              //0x27100
.section .text

_start: 

    ldr r0, =src_image_addr //esto solamente en arm, porque no tenemos control sobre donde se guarda la vara
    ldr r1, =src_image      //esto sí
    str r1, [r0]            //guarda se guarda la dirección del trozo de imagen a procesar
    mov r1, #0              //chunk counter/x offset
    mov r2, #0              //y offset
loop_image:
    cmp r2, #100            //compara si ya se llegó al offset vertical de 100, ya terminó
    bge exit
    curr_2x2_row:           //
    cmp r1, #100            //compara si ya terminó la fila (si ya llegó a 100)
    ble continue_loop      //si es menor al tamaño del source image, continúa
    mov r1, #0             //si es mayor: devuelve el offset horizontal a cero
    add r2, #2             //le agrega dos más al offset vertical
    b loop_image           //procrsa ese  nuevo chunk de 2x2
    continue_loop:

    //calcula la posición del chunk en la imagen (offset_lineal) con el offset horizontal (chunk_counter) y  el offset vertical
    mov r3, #0          //inicializa r3 en 0
    mov r9, #400
    mul r4, r2, r9      //offset_vertical*400
    add r3, r1, r4      //r3 <= inicio_imagen + offset_x+offset_y*400

    //superior izquierda
    //la esquina superior izquierda de nuestra matriz de interpolación es el offset, en sí
    ldrb r4, [r0, r3]    //guardamos el contenido de nuestra imagen+offset_lineal
    ldr r5, =esquina_si //r5 <= (direccion de esquina_si)
    strb r4, [r5]        //guardamos el contenido de la esquina en la variable esquina_si

    //superior derecha (un pixel mas)
    add r3, r3, #1 
    ldrb r4, [r0, r3]
    ldr r5, =esquina_sd
    strb r4, [r5]

    //inferior izquierda (399 pixeles mas)
    add r3, r3, #255
    add r3, r3, #144
    ldrb r4, [r0, r3]
    ldr r5, =esquina_ii
    strb r4, [r5]

    //inferior derecha (un pixel mas)
    add r3, r3, #1
    ldrb r4, [r0, r3]
    ldr r5, =esquina_id
    strb r4, [r5]

    bl intr_matrx_calculation //salto para calcular matriz de interpolación
    bl matrix_2_image         //salto para guardar matriz de interpolación en imagen resultante

    add r1, r1, #2            //seguir con el 2x2 de la derecha del actual
    b curr_2x2_row            //jump al siguiente 2x2 de la fila

intr_matrx_calculation:
    sides:
        push {r0-r5, lr}
        ldr r0, =interp_matrix

        //position 2
        mov r1, #1
        mov r2, #4
        ldr r3, =esquina_si
        ldr r4, =esquina_sd
        mov r5, #2

        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]
        
        //position 3
        mov r1, #1
        mov r2, #4
        ldr r3, =esquina_si
        ldr r4, =esquina_sd
        mov r5, #3

        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 5
        mov r1, #1
        mov r2, #13
        ldr r3, =esquina_si
        ldr r4, =esquina_ii
        mov r5, #5

        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 9
        mov r1, #1
        mov r2, #13
        ldr r3, =esquina_si
        ldr r4, =esquina_ii
        mov r5, #9

        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 14
        mov r1, #13
        mov r2, #16
        ldr r3, =esquina_ii
        ldr r4, =esquina_id
        mov r5, #14

        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 15
        mov r1, #13
        mov r2, #16
        ldr r3, =esquina_ii
        ldr r4, =esquina_id
        mov r5, #15

        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 8
        mov r1, #4
        mov r2, #16
        ldr r3, =esquina_sd
        ldr r4, =esquina_id
        mov r5, #8
        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 12
        mov r1, #4
        mov r2, #16
        ldr r3, =esquina_sd
        ldr r4, =esquina_id
        mov r5, #12
        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

    interior:

        //position 6
        mov r1, #5
        mov r2, #8
        ldrb r3, [r0, #4]
        ldrb r4, [r0, #7]
        mov r5, #6
        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 7
        mov r1, #5
        mov r2, #8
        ldrb r3, [r0, #4]
        ldrb r4, [r0, #7]
        mov r5, #7
        bl interpolation_for_nm

        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 10
        mov r1, #9
        mov r2, #12
        ldrb r3, [r0, #8]
        ldrb r4, [r0, #11]
        mov r5, #10
        
        add r5, r5, #-1
        strb r1, [r0, r5]

        //position 11
        mov r1, #9
        mov r2, #12
        ldrb r3, [r0, #8]
        ldrb r4, [r0, #11]
        mov r5, #11
        
        add r5, r5, #-1
        strb r1, [r0, r5]
    esquinas:
        //guarda posicion 1
        ldr r1, =esquina_si
        ldrb r1, [r1]
        strb r1, [r0]

        //guarda posicion 4
        ldr r1, =esquina_sd
        ldrb r1, [r1]
        strb r1, [r0, #3]

        //guarda posicion 13
        ldr r1, =esquina_ii
        ldrb r1, [r1]
        strb r1, [r0, #12]

        //guarda posicion 16
        ldr r1, =esquina_id
        ldrb r1, [r1]
        strb r1, [r0, #15]

        pop {r0-r5, lr}
        bx lr
matrix_2_image:
    push {r3-r9, lr}
    ldr r3, =interp_matrix //direccion de la matriz de interpolacion
    ldr r4, =improved_image //direccion de la imagen mejorada
    mov r5, #0  //fila
    mov r6, #0  //columna

    mov r7, r0  //x_offset of source image
    lsr r7, #2   //divide by 2 to obtain x_offset of result image

    mov r8, r1 //y_offset of the source image
    lsr r8, #2   //divide by 2 to obtain x_offset of result image
    mov r9, #200
    mul r8, r7, r9 //position in result image

    add r7, r7, r8 //initial position in interp matrix
    row_interp_loop:
        cmp r6, #16
        beq done_copying
        mov r5, #0
        column_interp_loop:
            ldrb r9, [r7]
            strb r9, [r4, r8]
            
            add r5, r5, #1      //i++
            add r7, r7, #1
            add r8, r8, #1
            cmp r5, #16
            bl column_interp_loop
            add r7, r7, #16     //cambio de columna en matriz
            add r8, r8, #200    //cambio de comlumna en imagen
            add r6, #1          //j++
            b row_interp_loop

    
    done_copying:
    pop {r3-r9, lr}
    bx lr

interpolation_for_nm:
    //r1=x1 posicion de esquina inicial
    //r2=x2 posición de esquina final
    //r3=v1 valor de esquina inicial
    //r4=v2 valor de esquina final
    //r5=x  posicion del valor a calcular
    push {r6-r9, lr}
    sub r6, r2, r5
    sub r7, r2, r1
    udiv r6, r6, r7
    mov r7, r6
    mul r6, r7, r3

    sub r8, r5, r1
    sub r9, r2, r1
    udiv r9, r9, r8
    movS r8, r9
    mul r9, r8, r4

    add r1, r9, r6

    pop {r6-r9, lr}
    bx lr

exit:
    b exit
    


    

    