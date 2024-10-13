module extend(input  logic [29:0] Instr, // Instrucciones de 30 bits
              input  logic [1:0]  ImmSrc,
              output logic [29:0] ExtImm); // Inmediato extendido a 30 bits

  always_comb
    case(ImmSrc)
      2'b00:   ExtImm = {22'b0, Instr[7:0]};         // 8-bit unsigned immediate
      2'b01:   ExtImm = {18'b0, Instr[11:0]};        // 12-bit unsigned immediate
      2'b10:   ExtImm = {{6{Instr[29]}}, Instr[29:0]}; // Branch, extendiendo signo
      default: ExtImm = 30'bx;                        // Undefined
    endcase
	 
endmodule

