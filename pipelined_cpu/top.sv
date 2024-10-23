module top(input  logic        clk, reset,
           output logic [31:0] WriteDataM, DataAdrM,
           output logic        MemWriteM);
			  
  logic [31:0] PCF, InstrF, ReadDataM;

  // instantiate processor and memories
  cpu cpu(clk, reset, PCF, InstrF, MemWriteM, DataAdrM, WriteDataM, ReadDataM);
  
  imem imem(PCF, InstrF);

    RAMMemory ram1(
    .clock(clk),
	 .wren(MemWriteM),
    .address(DataAdrM),
    .data(WriteDataM),
    .q(ReadDataM)
  );
endmodule