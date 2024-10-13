module alu(input  logic [18:0] a, b,              // Registros de 19 bits
           input  logic [1:0]  ALUControl,
           output logic [29:0] Result,            // Instrucciones de 30 bits
           output logic [3:0]  Flags);

  logic neg, zero, carry, overflow;
  logic [18:0] condinvb;                          // Inverso condicionado de 19 bits
  logic [19:0] sum;                               // Suma con carry extendido

  assign condinvb = ALUControl[0] ? ~b : b;
  assign sum = a + condinvb + ALUControl[0];      // Operación de suma/resta con carry

  always_comb
    casex (ALUControl[1:0])
      2'b0?: Result = sum[18:0];                 // Resultado de suma o resta truncado a 19 bits
      2'b10: Result = a * b;                     // Multiplicación
      2'b11: Result = a / b;                     // División
    endcase
	 
  // Cálculo de los flags
  assign neg = Result[18];                        // Bit más significativo de 19 bits
  assign zero = (Result == 30'b0);                // Comparación con 30 bits en 0
  assign carry = (ALUControl[1] == 1'b0) & sum[19]; // Carry en la suma
  assign overflow = (ALUControl[1] == 1'b0) & 
                    ~(a[18] ^ b[18] ^ ALUControl[0]) & 
                    (a[18] ^ sum[18]);            // Overflow para suma/resta

  assign Flags = {neg, zero, carry, overflow};    // Empaquetado de los flags
  
endmodule
