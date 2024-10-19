_start:
    LOAD r0, image
    MOVE r1, #0      //chunk counter
    MOVE r2, #0      //y offset
_loopImage:
    COMP r2, #100
    SMAI exit
    _curr2x2row:
    COMP r1, #100
    SMEI continueLoop
    MOVE r1, #0
    SUMA r2, #2
    SALT loopImage
    _continueLoop:

    //offset adding
    MOVE r3, #0
    MULT r4, r2, #100
    SUMA r3, r1, r4 //add chunk_counter*vertical_offset

    //superior izquierda
    LOAD r4, [r0, r3]
    LOAD r5, =esquinaSI
    STOR r4, [r5]

    //superior derecha
    SUMA r3, r3, #1
    LOAD r4, [r0, r3]
    STOR r5, =esquinaSD
    STOR r4, [r5]

    //inferior izquierda
    SUMA r3, r3, #99
    LOAD r4, [r0, r3]
    STOR r5, =esquinaII
    STOR r4, [r5]

    //inferior derecha
    SUMA r3, r3, #1
    LOAD r4, [r0, r3]
    STOR r5, =esquinaID
    STOR r4, [r5]

    SYCA _intrMatrixCalculation


    SUMA r1, r1, #2
    SYEN _curr2x2row
_intrMatrixCalculation:
    _sides:
        PUSH{r0-r5, lr}
        LOAD r0, =interpMatrix

        //position 2
        MOVE r1, #1
        MOVE r2, #4
        LOAD r3, esquinaSI
        LOAD r4, esquinaSD
        MOVE r5, #2

        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 3
        MOVE r1, #1
        MOVE r2, #4
        LOAD r3, esquinaSI
        LOAD r4, esquinaSD
        MOVE r5, #3

        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 5
        MOVE r1, #1
        MOVE r2, #13
        LOAD r3, esquinaSI
        LOAD r4, esquinaII
        MOVE r5, #5

        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 9
        MOVE r1, #1
        MOVE r2, #13
        LOAD r3, esquinaSI
        LOAD r4, esquinaII
        MOVE r5, #9

        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 14
        MOVE r1, #13
        MOVE r2, #16
        LOAD r3, esquinaII
        LOAD r4, esquinaID
        MOVE r5, #14

        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 15
        MOVE r1, #13
        MOVE r2, #16
        LOAD r3, esquinaII
        LOAD r4, esquinaID
        MOVE r5, #15

        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 8
        MOVE r1, #4
        MOVE r2, #16
        LOAD r3, esquinaSD
        LOAD r4, esquinaID
        MOVE r5, #8
        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 12
        MOVE r1, #4
        MOVE r2, #16
        LOAD r3, esquinaSD
        LOAD r4, esquinaID
        MOVE r5, #12
        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]
    _interior:

        //position 6
        MOVE r1, #5
        MOVE r2, #8
        LOAD r3, [r0, #4]
        LOAD r4, [r0, #7]
        MOVE r5, #6
        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 7
        MOVE r1, #5
        MOVE r2, #8
        LOAD r3, [r0, #4]
        LOAD r4, [r0, #7]
        MOVE r5, #7
        SYCA interpolationForNM

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 10
        MOVE r1, #9
        MOVE r2, #12
        LOAD r3, [r0, #8]
        LOAD r4, [r0, #11]
        MOVE r5, #10

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]

        //position 11
        MOVE r1, #9
        MOVE r2, #12
        LOAD r3, [r0, #8]
        LOAD r4, [r0, #11]
        MOVE r5, #11

        SUMA r5, r5, #-1
        STOR r1, [r0, r5]
    _esquinas:
        //guarda posicion 1
        LOAD r1, =esquinaSI
        LOAD r1, [r1]
        STOR r1, [r0]

        //guarda posicion 4
        LOAD r1, =esquinaSD
        LOAD r1, [r1]
        STOR r1, [r0, #3]

        //guarda posicion 13
        LOAD r1, =esquinaII
        LOAD r1, [r1]
        STOR r1, [r0, #12]

        //guarda posicion 16
        LOAD r1, =esquinaID
        LOAD r1, [r1]
        STOR r1, [r0, #15]

        REST{r0-r5, lr}
        SYEN lr
_matrixToImage:
    LOAD r3, = IMP_IMAGE
    // CONSULTAR DONDE SE GUARDA LA MATRIZ 2x2



_interpolationForNM:
    //r1=x1 posicion de esquina inicial
    //r2=x2 posición de esquina final
    //r3=v1 valor de esquina inicial
    //r4=v2 valor de esquina final
    //r5=x  posicion del valor a calcular
    PUSH {r2-r9, lr}
    SUST r6, r2, r5
    SUST r7, r2, r1
    DIVI r6, r6, r7
    MULT r6, r6, r3

    SUST r8, r5, r1
    SUST r9, r2, r1
    DIVI r9, r9, r8
    MULT r9, r9, r4

    SUMA r1, r9, r6

    REST {r2-r9, lr}
    SYEN lr