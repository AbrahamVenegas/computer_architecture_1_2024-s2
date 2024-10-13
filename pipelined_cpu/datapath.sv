module datapath(input  logic        clk, reset,
                input  logic [1:0]  RegSrcD, ImmSrcD,
                input  logic        ALUSrcE, BranchTakenE,
                input  logic [1:0]  ALUControlE,
                input  logic        MemtoRegW, PCSrcW, RegWriteW,
                output logic [29:0] PCF, 
                input  logic [29:0] InstrF, 
                output logic [29:0] InstrD, 
                output logic [29:0] ALUOutM, WriteDataM,
                input  logic [29:0] ReadDataM, 
                output logic [3:0]  ALUFlagsE,

                // hazard logic
                output logic        Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
                input  logic [1:0]  ForwardAE, ForwardBE,
                input  logic        StallF, StallD, FlushD);

  logic [29:0] PCPlus4F, PCnext1F, PCnextF; 
  logic [29:0] ExtImmD, rd1D, rd2D, PCPlus8D;
  logic [29:0] rd1E, rd2E, ExtImmE, SrcAE, SrcBE, WriteDataE, ALUResultE;
  logic [29:0] ReadDataW, ALUOutW, ResultW;
  logic [3:0]  RA1D, RA2D, RA1E, RA2E, WA3E, WA3M, WA3W;
  logic        Match_1D_E, Match_2D_E;

  // Fetch stage
  mux2 #(30) pcnextmux(PCPlus4F, ResultW, PCSrcW, PCnext1F);
  mux2 #(30) branchmux(PCnext1F, ALUResultE, BranchTakenE, PCnextF); 
  flipflopenr #(30) pcreg(clk, reset, ~StallF, PCnextF, PCF); 
  adder #(30) pcadd(PCF, 30'h4, PCPlus4F); 

  // Decode Stage
  assign PCPlus8D = PCPlus4F; // skip register
  flipflopenrc #(30) instrreg(clk, reset, ~StallD, FlushD, InstrF, InstrD); 
  mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrcD[0], RA1D);
  mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrcD[1], RA2D);
  regfile rf(clk, RegWriteW, RA1D, RA2D, WA3W, ResultW, PCPlus8D, rd1D, rd2D);
  extend ext(InstrD[29:0], ImmSrcD, ExtImmD); 

  // Execute Stage
  flipflopr #(30) rd1reg(clk, reset, rd1D, rd1E);
  flipflopr #(30) rd2reg(clk, reset, rd2D, rd2E); 
  flipflopr #(30) immreg(clk, reset, ExtImmD, ExtImmE); 
  flipflopr #(4) wa3ereg(clk, reset, InstrD[15:12], WA3E);
  flipflopr #(4) ra1reg(clk, reset, RA1D, RA1E);
  flipflopr #(4) ra2reg(clk, reset, RA2D, RA2E);
  mux3 #(30) byp1mux(rd1E, ResultW, ALUOutM, ForwardAE, SrcAE); 
  mux3 #(30) byp2mux(rd2E, ResultW, ALUOutM, ForwardBE, WriteDataE); 
  mux2 #(30) srcbmux(WriteDataE, ExtImmE, ALUSrcE, SrcBE); 
  alu alu(SrcAE, SrcBE, ALUControlE, ALUResultE, ALUFlagsE);

  // Memory Stage
  flipflopr #(30) aluresreg(clk, reset, ALUResultE, ALUOutM); 
  flipflopr #(30) wdreg(clk, reset, WriteDataE, WriteDataM);
  flipflopr #(4) wa3mreg(clk, reset, WA3E, WA3M);

  // Writeback Stage
  flipflopr #(30) aluoutreg(clk, reset, ALUOutM, ALUOutW); 
  flipflopr #(30) rdreg(clk, reset, ReadDataM, ReadDataW); 
  flipflopr #(4) wa3wreg(clk, reset, WA3M, WA3W);
  mux2 #(30) resmux(ALUOutW, ReadDataW, MemtoRegW, ResultW); 

  // hazard comparison
  eqcmp #(4) m0(WA3M, RA1E, Match_1E_M);
  eqcmp #(4) m1(WA3W, RA1E, Match_1E_W);
  eqcmp #(4) m2(WA3M, RA2E, Match_2E_M);
  eqcmp #(4) m3(WA3W, RA2E, Match_2E_W);
  eqcmp #(4) m4a(WA3E, RA1D, Match_1D_E);
  eqcmp #(4) m4b(WA3E, RA2D, Match_2D_E);

  assign Match_12D_E = Match_1D_E | Match_2D_E;
  
endmodule
