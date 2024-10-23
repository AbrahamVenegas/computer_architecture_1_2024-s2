`timescale 1ns / 1ps

module decoder_tb;

    // Inputs
    logic [1:0] Op;
    logic [5:0] Funct;
    logic [3:0] Rd;
    logic [3:0] Em;

    // Outputs
    logic [1:0] FlagW;
    logic       PCS, RegW, MemW, MemtoReg, ALUSrc;
    logic [1:0] ImmSrc, RegSrc;
    logic [3:0] ALUControl;
    logic [4:0] SHIFTControl;
    logic       BranchLinkEn, BranchD;
    logic [3:0] ByteEn;

    // Instantiate the decoder module
    decoder uut (
        .Op(Op), .Funct(Funct), .Rd(Rd), .Em(Em),
        .FlagW(FlagW), .PCS(PCS), .RegW(RegW), .MemW(MemW),
        .MemtoReg(MemtoReg), .ALUSrc(ALUSrc), .ImmSrc(ImmSrc), 
        .RegSrc(RegSrc), .ALUControl(ALUControl), .SHIFTControl(SHIFTControl),
        .BranchLinkEn(BranchLinkEn), .BranchD(BranchD), .ByteEn(ByteEn)
    );

    // Testbench logic
    initial begin
        // Test Case 1: Data-processing immediate instruction
        Op = 2'b00; Funct = 6'b100000; Em = 4'b0000; Rd = 4'b0001;
        #10;
        $display("Test 1: Op=%b, Funct=%b -> RegW=%b, ALUSrc=%b, MemW=%b",
                 Op, Funct, RegW, ALUSrc, MemW);

        // Test Case 2: Load instruction (LDR)
        Op = 2'b01; Funct = 6'b000100; Em = 4'b0000; Rd = 4'b0001;
        #10;
        $display("Test 2: Op=%b, Funct=%b -> MemtoReg=%b, MemW=%b",
                 Op, Funct, MemtoReg, MemW);

        // Test Case 3: Branch instruction (BL)
        Op = 2'b10; Funct = 6'b000010; Em = 4'b0000; Rd = 4'b1111;
        #10;
        $display("Test 3: Op=%b, Funct=%b -> PCS=%b, BranchLinkEn=%b",
                 Op, Funct, PCS, BranchLinkEn);

        // Finish simulation
        $finish;
    end
endmodule
