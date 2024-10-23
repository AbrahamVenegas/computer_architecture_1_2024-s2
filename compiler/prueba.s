_start:
SUMA G3, G3, #1
MOVE G1, #9
COMP G2, #100
SUST G6, G2, G5
DIVI G6, G6, G7
MULT G6, G6, G3
STOR G5, =esquinaSD
STOR G4, [r5]
LOAD G0, image
LOAD G4, [G0, G3]
LOAD G5, =esquinaSI
PUSH{G0-G5, lr}
REST{G0-G5, lr}
SMAI _exit
SMEI _continueLoop
SYCA _intrMatrixCalculation
SYEN _curr2x2row
SALT _loopImage