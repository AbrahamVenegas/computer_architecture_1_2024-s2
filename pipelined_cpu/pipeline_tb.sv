`timescale 1ns / 1ps

module pipeline_tb;

  // Señales del testbench
  logic        clk, reset;
  logic [31:0] WriteDataM, DataAdrM, ReadDataM;
  logic        MemWriteM;

  // Instancia del top module
  top dut (
    .clk(clk),
    .reset(reset),
    .WriteDataM(WriteDataM),
    .DataAdrM(DataAdrM),
    .MemWriteM(MemWriteM)
  );

  // Generación del reloj (10ns por ciclo)
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  // Generación de reset
  initial begin
    reset = 1'b1;
    #30;
    reset = 1'b0;
  end

  // Monitoreo de registros y memoria en cada ciclo del pipeline
  initial begin
    $monitor("Time: %0t | PC: %h | MemWrite: %b | Addr: %h | Data: %h", 
              $time, dut.cpu.PCF, MemWriteM, DataAdrM, WriteDataM);
  end

  // Proceso de prueba
  initial begin
    @(negedge reset);  // Esperar a que se desactive el reset

    // Esperar algunos ciclos para permitir la ejecución de instrucciones
    repeat (100) @(posedge clk);


    // Finalizar la simulación
    $stop;
  end


 

endmodule
