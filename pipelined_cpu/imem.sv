module imem(input  logic [31:0] a,
            output logic [31:0] rd);

  logic [31:0] RAM[63:0];

  initial
    $readmemh("C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/mefilethree.dat",RAM);

  assign rd = RAM[a[22:2]]; // word aligned
  
endmodule