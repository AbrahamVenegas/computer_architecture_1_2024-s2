`timescale 1ns / 1ps

module dmem_tb;

    // Inputs
    logic clk, we;
    logic [31:0] a;   // Address
    logic [31:0] wd;  // Write data
    logic [3:0] ByteEn;

    // Outputs
    logic [31:0] rd;  // Read data

    // Instantiate the dmem module
    dmem uut (
        .clk(clk), .we(we), .a(a), .wd(wd), .rd(rd), .ByteEn(ByteEn)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Testbench logic
    initial begin
        // Test Case 1: Write 32'hDEADBEEF to address 0x00000004
        we = 1; a = 32'h00000004; wd = 32'hDEADBEEF; ByteEn = 4'b1111;
        #10;
        we = 0;  // Disable write

        // Test Case 2: Read back from address 0x00000004
        #10;
        $display("Read Data from 0x00000004: %h", rd);

        // Test Case 3: Write byte (0xAA) to address 0x00000006
        we = 1; a = 32'h00000006; wd = 32'h000000AA; ByteEn = 4'b0001;
        #10;
        we = 0;

        // Test Case 4: Read back byte from 0x00000006
        #10;
        $display("Read Byte from 0x00000006: %h", rd);

        // Finish simulation
        $finish;
    end
endmodule
