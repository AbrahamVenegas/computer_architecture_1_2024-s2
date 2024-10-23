 .text
 _start:
    LDR     R1, =0x12345678   
    LDR     R0, =0x0          
    STR     R1, [R0]          
    LDR     R2, [R0]          

    MOV     R3, #0xFF             
    LDR     R0, =0x28          
    STRB    R3, [R0]           
    LDRB    R4, [R0]           

    LDR     R5, =0x87654321     
    LDR     R0, =0x0 
    STR     R5, [R0, #4]
    LDR     R6, [R0, #4] 

    MOV     R7, #0xAA 
    LDR     R0, =0x28
    STRB    R7, [R0, #1]
    LDRB    R8, [R0, #1]
end:
    B       end 

_start;
    mov r1, #4
    mov r2, #2
    add r3, r2, r1
end:
    B       end