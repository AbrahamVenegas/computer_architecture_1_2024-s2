_start:
    ldr r0, #0x0 //carga la direccion de la variable que contiene la base del fragmento seleccionado
    ldr r0, [r0]     //carga la direccion del fragmento selccionado en r0
    mov r1, #0
    mov r2, #0
loop_image:
    cmp r2, #100        //compara si ya llegó al offset vertial de 100 interpolando todo el fragmento
    bge exit
curr_2x2_row:
    cmp r1, #100        //compara si ya terminó la fila (si ya llegó a 100)
    ble continue_loop   //si es menor al tamaño del source image, continúa
    mov r1, #0          //si es mayor: devuelve el offset horizontal a cero
    add r2, #2          //le agrega dos más al offset vertical
    b loop_image        //procrsa ese  nuevo chunk de 2x2
continue_loop:          //calcula la posición del chunk en la imagen (offset_lineal) con el offset horizontal (chunk_counter) y  el offset vertical
    mov r3, #0
    mov r9, #255        
    add r9, r9, #145    //ssuma 145 los 255, para el ancho de imagen 400
    mul r4, r2, r9      //offset_vertical*400
    add r3, r1, r4      //r3 <= inicio_imagen + offset_x+offset_y*400
    ldrb r4, [r0, r3]   //superior izquierda //guardamos el contenido de nuestra imagen+offset_lineal
    ldrb r5, =0x4       //r5 <= (direccion de esquina_si)
    strb r4, [r5]       //guardamos el contenido de la esquina en la variable esquina_si
    add r3, r3, #1      //superior derecha (un pixel mas)
    ldrb r4, [r0, r3]
    ldr r5, =0x5
    strb r4, [r5]
    add r3, r3, #255    //inferior izquierda (399 pixeles mas)
    add r3, r3, #144
    ldrb r4, [r0, r3]
    ldr r5, =0x6
    strb r4, [r5]
    add r3, r3, #1      //inferior derecha (un pixel mas)
    ldrb r4, [r0, r3]
    ldr r5, =0x7
    strb r4, [r5]
    bl intr_matrx_calculation
    bl matrix_2_image
    add r1, r1, #2
    b curr_2x2_row
intr_matrx_calculation:
sides:
    push {r0-r5, lr}
    ldr r0, =0x4e20
    mov r1, #1
    mov r2, #4
    ldr r3, =0x4 //si
    ldr r4, =0x5 //sd
    mov r5, #2
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #1
    mov r2, #4
    ldr r3, =0x4 //si
    ldr r4, =0x5 //sd
    mov r5, #3
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #1
    mov r2, #13
    ldr r3, =0x4 //si
    ldr r4, =0x6 //ii
    mov r5, #5
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #1
    mov r2, #13
    ldr r3, =0x4 //si
    ldr r4, =0x6 //ii
    mov r5, #9
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #13
    mov r2, #16
    ldr r3, =0x6 //ii
    ldr r4, =0x7 //id
    mov r5, #14
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #13
    mov r2, #16
    ldr r3, =0x6 //ii
    ldr r4, =0x8 //id
    mov r5, #15
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #4
    mov r2, #16
    ldr r3, =0x5 //sd
    ldr r4, =0x7 //id
    mov r5, #8
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #4
    mov r2, #16
    ldr r3, =0x5 //sd
    ldr r4, =0x7 //id
    mov r5, #12
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
interior:
    mov r1, #5
    mov r2, #8
    ldrb r3, [r0, #4]
    ldrb r4, [r0, #7]
    mov r5, #6
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #5
    mov r2, #8
    ldrb r3, [r0, #4]
    ldrb r4, [r0, #7]
    mov r5, #7
    bl interpolation_for_nm
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #9
    mov r2, #12
    ldrb r3, [r0, #8]
    ldrb r4, [r0, #11]
    mov r5, #10
    add r5, r5, #-1
    strb r1, [r0, r5]
    mov r1, #9
    mov r2, #12
    ldrb r3, [r0, #8]
    ldrb r4, [r0, #11]
    mov r5, #11
    add r5, r5, #-1
    strb r1, [r0, r5]
esquinas:
    ldr r1, =0x4 //si
    ldrb r1, [r1]
    strb r1, [r0]
    ldr r1, =0x5 //sd
    ldrb r1, [r1]
    strb r1, [r0, #3]
    ldr r1, =0x6 //ii
    ldrb r1, [r1]
    strb r1, [r0, #12]
    ldr r1, =0x7 //id
    ldrb r1, [r1]
    strb r1, [r0, #15]
    pop {r0-r5, lr}
    bx lr
matrix_2_image:
    push {r3-r9, lr}
    ldr r3, =0x8 //interp_matrix
    ldr r4, =0x27118 //improved_image
    mov r5, #0
    mov r6, #0
    mov r7, r0
    lsr r7, #2
    mov r8, r1
    lsr r8, #2
    mov r9, #200
    mul r8, r7, r9
    add r7, r7, r8
row_interp_loop:
    cmp r6, #16
    beq done_copying
    mov r5, #0
column_interp_loop:
    ldrb r9, [r7]
    strb r9, [r4, r8]
    add r5, r5, #1
    add r7, r7, #1
    add r8, r8, #1
    cmp r5, #16
    bl column_interp_loop
    add r7, r7, #16
    add r8, r8, #200
    add r6, #1
    b row_interp_loop
done_copying:
    pop {r3-r9, lr}
    bx lr
interpolation_for_nm:
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
