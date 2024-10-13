module regfile(input  logic        clk,
               input  logic        we3,
               input  logic [3:0]  ra1, ra2, wa3,
               input  logic [18:0] wd3, r15,
               output logic [18:0] rd1, rd2);
					
  logic [18:0] rf[14:0]; // 9 registros
  
  // banco de registros de 3 puertos
  // se leen dos puertos combinacionalmente
  // La escritura se realiza en el flanco negativo del reloj
  // Esto permite que los datos escritos puedan ser leídos en el mismo ciclo.
  // el registro 15 lee PC + 8

  always_ff @(negedge clk)
    if (we3) rf[wa3] <= wd3;
      
  assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
  assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
  
endmodule